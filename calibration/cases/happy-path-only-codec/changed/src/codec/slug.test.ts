import { encodeSlug } from "./slug";

/**
 * SEEDED DEFECT (missing PBT / weak oracle): pure string algebra covered by a
 * single happy-path example. No empty string, no unicode, no idempotence property,
 * no Hypothesis/fast-check. Project already "should" use PBT for codecs (see skill §6.6).
 */
test("encodes a simple title", () => {
  expect(encodeSlug("Hello World")).toBe("hello-world");
});
