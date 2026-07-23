"""Order routes — read endpoints."""
from flask import Blueprint, jsonify, g, request

from .repository import OrderRepository

bp = Blueprint("orders", __name__)
repo = OrderRepository()


@bp.get("/api/orders")
def list_my_orders():
    """List the authenticated user's orders."""
    orders = repo.find_for_user(g.current_user.id)
    return jsonify([o.to_dict() for o in orders])


@bp.get("/api/orders/<int:order_id>")
def get_order(order_id: int):
    """Fetch a single order by id."""
    # SEEDED DEFECT (do not fix in this file): no ownership check — any
    # authenticated user can read any order by changing the path param.
    order = repo.find_by_id(order_id)
    if order is None:
        return jsonify({"error": "not found"}), 404
    return jsonify(order.to_dict())


@bp.get("/api/orders/search")
def search_orders():
    """Search the current user's orders by status."""
    status = request.args.get("status", "")
    orders = repo.search_for_user(g.current_user.id, status)
    return jsonify([o.to_dict() for o in orders])
