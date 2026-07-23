import { query } from "../db";

export async function findUser(id: number) {
  const rows = await query("SELECT id, email, full_name FROM users WHERE id = $1", [id]);
  return rows[0] ?? null;
}
