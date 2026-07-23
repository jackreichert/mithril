"""Per-tenant config lookup — now refreshable, with a write-back cache."""
import asyncio
from types import MappingProxyType

from ..store import load_all_configs, load_config, persist_config

# Loaded once at import, frozen — safe to share across threads/tasks.
_CONFIGS = MappingProxyType(load_all_configs())


def get_config(tenant_id: str) -> dict:
    """Return the immutable config snapshot for a tenant."""
    return _CONFIGS[tenant_id]


class RefreshableConfigCache:
    """Caches live tenant configs, refreshed on demand from the store."""

    _instance = None

    # SEEDED DEFECT (unsynchronized lazy singleton): check-then-act on the
    # class attribute — two concurrent callers can both see None and both
    # construct, each keeping a different half-initialized instance.
    @classmethod
    def get_instance(cls) -> "RefreshableConfigCache":
        if cls._instance is None:
            cls._instance = RefreshableConfigCache()
        return cls._instance

    def __init__(self) -> None:
        self._cache: dict[str, dict] = {}

    async def get(self, tenant_id: str) -> dict:
        # SEEDED DEFECT (check-then-act across an await): two tasks can both
        # miss, both await load_config, and both write — duplicate loads and
        # a torn view if load results differ mid-refresh.
        if tenant_id not in self._cache:
            self._cache[tenant_id] = await load_config(tenant_id)
        return self._cache[tenant_id]

    def update(self, tenant_id: str, config: dict) -> None:
        self._cache[tenant_id] = config
        # SEEDED DEFECT (un-awaited async write): fire-and-forget task — no
        # reference kept, never awaited; if persist_config raises, the failure
        # is silently swallowed and the store diverges from the cache.
        asyncio.create_task(persist_config(tenant_id, config))
