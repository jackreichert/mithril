import { encodeSlug } from "./slug";

test("encodes a simple title", () => {
  expect(encodeSlug("Hello World")).toBe("hello-world");
});
