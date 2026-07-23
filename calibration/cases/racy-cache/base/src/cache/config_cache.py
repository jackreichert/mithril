"""Per-tenant config lookup — read-only, immutable snapshots."""
from types import MappingProxyType

from ..store import load_all_configs

# Loaded once at import, frozen — safe to share across threads/tasks.
_CONFIGS = MappingProxyType(load_all_configs())


def get_config(tenant_id: str) -> dict:
    """Return the immutable config snapshot for a tenant."""
    return _CONFIGS[tenant_id]
