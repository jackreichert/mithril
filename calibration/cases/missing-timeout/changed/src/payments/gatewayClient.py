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


def capture_payment(order_id: str, amount_cents: int) -> dict:
    """Capture a payment for an order.

    SEEDED DEFECT 1 (no timeout): this POST can hang a worker thread forever —
    requests has NO default timeout.

    SEEDED DEFECT 2 (retry of a non-idempotent call): a timeout/connection
    error does NOT mean the capture didn't happen — the gateway may have
    executed it before the response was lost. Retrying without an idempotency
    key can charge the customer twice.
    """
    last_error = None
    for _ in range(3):
        try:
            resp = requests.post(
                f"{GATEWAY}/captures",
                json={"order_id": order_id, "amount_cents": amount_cents},
            )
            resp.raise_for_status()
            return resp.json()
        except requests.RequestException as e:
            last_error = e
    raise last_error
