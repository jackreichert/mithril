"""Order routes — read endpoints."""
from flask import Blueprint, jsonify, g

from .repository import OrderRepository

bp = Blueprint("orders", __name__)
repo = OrderRepository()


@bp.get("/api/orders")
def list_my_orders():
    """List the authenticated user's orders."""
    orders = repo.find_for_user(g.current_user.id)
    return jsonify([o.to_dict() for o in orders])
