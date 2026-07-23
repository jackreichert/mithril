"""Payment-gateway HTTP client."""
import requests

GATEWAY = "https://gateway.example.com"
DEFAULT_TIMEOUT = 5  # seconds


def get_payment_status(payment_id: str) -> dict:
    """Clean path: bounded wait, idempotent GET, safe to retry."""
    resp = requests.get(
        f"{GATEWAY}/payments/{payment_id}",
        timeout=DEFAULT_TIMEOUT,
    )
    resp.raise_for_status()
    return resp.json()
