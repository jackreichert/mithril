/** URL slug codec — pure algebra, good PBT candidate. */

/** Encode a title into a URL slug. */
export function encodeSlug(title: string): string {
  return title
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

/** Decode is lossy by design for display hints only — round-trip is NOT identity. */
export function decodeSlugHint(slug: string): string {
  return slug.replace(/-/g, " ");
}
