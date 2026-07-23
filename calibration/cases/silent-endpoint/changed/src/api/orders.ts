/** Orders read API — new refund path ships dark. */

export type Order = { id: string; userId: string; totalCents: number };

export interface OrderStore {
  get(id: string): Promise<Order | null>;
  /** Marks order refunded — money path. */
  markRefunded(id: string): Promise<void>;
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

/**
 * SEEDED DEFECT (silent user-facing mutation): refund endpoint has
 * - no metrics (rate/error/latency/saturation)
 * - no structured logs
 * - no request_id / trace context
 * - no SLO-oriented error counter
 * Failures are invisible in production.
 */
export async function refundOrder(store: OrderStore, orderId: string): Promise<void> {
  const order = await store.get(orderId);
  if (!order) {
    throw new Error("not found");
  }
  await store.markRefunded(orderId);
}
