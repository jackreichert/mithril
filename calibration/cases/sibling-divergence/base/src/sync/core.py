"""Shared clinician-sync defaults. Every EMR integration builds on SyncSpec."""
from dataclasses import dataclass


@dataclass(frozen=True)
class SyncSpec:
    name: str
    # A full-roster feed is authoritative: anyone absent from it has left.
    archive_missing: bool = True
    page_size: int = 100


def run_sync(spec: SyncSpec, feed: list[dict], store) -> None:
    seen = set()
    for row in feed:
        store.upsert(spec.name, row["external_id"], row)
        seen.add(row["external_id"])
    if spec.archive_missing:
        for external_id in store.active_ids(spec.name) - seen:
            store.archive(spec.name, external_id)
