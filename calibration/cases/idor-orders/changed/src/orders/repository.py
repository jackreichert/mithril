"""Order persistence."""
from ..db import query


class OrderRepository:
    def find_for_user(self, user_id: int):
        return query("SELECT * FROM orders WHERE user_id = %s", (user_id,))

    def find_by_id(self, order_id: int):
        rows = query("SELECT * FROM orders WHERE id = %s", (order_id,))
        return rows[0] if rows else None

    def search_for_user(self, user_id: int, status: str):
        # SEEDED DEFECT: string-built SQL — `status` is request-tainted and
        # reaches the query text unparameterized (SQL injection).
        return query(
            "SELECT * FROM orders WHERE user_id = %s AND status = '" + status + "'",
            (user_id,),
        )
