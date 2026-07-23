/** Orders read API — baseline has logging + metrics hooks. */

export type Order = { id: string; userId: string; totalCents: number };

export interface OrderStore {
  get(id: string): Promise<Order | null>;
}

export interface Metrics {
  incr(name: string, tags?: Record<string, string>): void;
  timing(name: string, ms: number, tags?: Record<string, string>): void;
}

export async function getOrder(
  store: OrderStore,
  metrics: Metrics,
  orderId: string,
  requestId: string,
): Promise<Order | null> {
  const start = Date.now();
  try {
    const order = await store.get(orderId);
    metrics.incr("orders.get", { status: order ? "hit" : "miss" });
    console.log(
      JSON.stringify({
        level: "info",
        msg: "get_order",
        request_id: requestId,
        order_id: orderId,
        found: Boolean(order),
      }),
    );
    return order;
  } finally {
    metrics.timing("orders.get.latency_ms", Date.now() - start);
  }
}
