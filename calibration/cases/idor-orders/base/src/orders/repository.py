"""Order persistence."""
from ..db import query


class OrderRepository:
    def find_for_user(self, user_id: int):
        return query("SELECT * FROM orders WHERE user_id = %s", (user_id,))
