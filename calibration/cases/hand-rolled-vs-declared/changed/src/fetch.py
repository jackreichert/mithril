import requests
from tenacity import retry, stop_after_attempt, wait_exponential


@retry(stop=stop_after_attempt(3), wait=wait_exponential(min=1, max=8))
def fetch_roster(url: str) -> dict:
    """Existing, clean: retries come from the declared tenacity dependency."""
    response = requests.get(url, timeout=10)
    response.raise_for_status()
    return response.json()
