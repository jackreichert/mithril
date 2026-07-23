/** Health check — structured, boring, instrumented. */

export type Health = { status: "ok"; service: string };

/** Clean bait: intentional minimal surface; logging a single structured line is fine. */
export function healthz(): Health {
  const body = { status: "ok" as const, service: "orders-api" };
  // structured, no PII, low cardinality
  console.log(JSON.stringify({ level: "info", msg: "healthz", ...body }));
  return body;
}
