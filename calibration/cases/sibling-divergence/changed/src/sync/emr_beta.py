"""Beta EMR clinician sync: returns the full roster on every run."""
from .core import SyncSpec

# SEEDED DEFECT: archive_missing is switched off with no reason given. Beta
# sends a full roster just like Alpha, so clinicians who leave are never
# archived and stay schedulable. The sibling (emr_alpha.py) and the shared
# default in core.py both archive.
# Beta's API rejects pages above 25 rows (stated divergence, clean bait).
BETA = SyncSpec(name="beta", archive_missing=False, page_size=25)
