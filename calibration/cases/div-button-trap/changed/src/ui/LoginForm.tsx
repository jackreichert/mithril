import React from "react";

/** Clean bait: native controls, labels, keyboard-friendly. */
export function LoginForm(props: { onSubmit: (email: string) => void }) {
  const [email, setEmail] = React.useState("");
  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        props.onSubmit(email);
      }}
    >
      <label htmlFor="email">Email</label>
      <input
        id="email"
        name="email"
        type="email"
        autoComplete="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />
      <button type="submit">Sign in</button>
    </form>
  );
}
