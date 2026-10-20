import time

import arrow  # SEEDED DEFECT (new near-duplicate dependency): added for one parse call; python-dateutil is already declared and parses the same input
import requests


def parse_start(text: str):
    return arrow.get(text).datetime


def fetch_shifts(url: str) -> list:
    """SEEDED DEFECT (hand-rolled retry): tenacity is already declared and used in fetch.py."""
    delay = 1
    for attempt in range(3):
        try:
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            return response.json()
        except requests.RequestException:
            if attempt == 2:
                raise
            time.sleep(delay)
            delay *= 2
    return []


def shift_label(shift_id: int) -> str:
    """Clean bait: three lines, and no declared dependency does this."""
    return f"shift-{shift_id:05d}"
