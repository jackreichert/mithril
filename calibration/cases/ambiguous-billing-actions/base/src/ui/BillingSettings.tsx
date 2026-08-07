import React from "react";

export function BillingSettings(props: {
  accountName: string;
  onSave: (accountName: string) => Promise<void>;
  onCancelAtPeriodEnd: () => void;
}) {
  const [accountName, setAccountName] = React.useState(props.accountName);
  const [saveState, setSaveState] = React.useState<
    "idle" | "saving" | "saved" | "error"
  >("idle");

  async function saveBillingProfile(event: React.FormEvent) {
    event.preventDefault();
    setSaveState("saving");
    try {
      await props.onSave(accountName);
      setSaveState("saved");
    } catch {
      setSaveState("error");
    }
  }

  return (
    <main>
      <h1>Billing settings</h1>
      <form onSubmit={saveBillingProfile}>
        <label htmlFor="account-name">Account name</label>
        <input
          id="account-name"
          value={accountName}
          onChange={(event) => setAccountName(event.target.value)}
        />
        <button type="submit" disabled={saveState === "saving"}>
          {saveState === "saving" ? "Saving" : "Save billing profile"}
        </button>
        <p role="status">
          {saveState === "saved" && "Billing profile saved."}
          {saveState === "error" && "Could not save. Try again."}
        </p>
      </form>

      <section aria-labelledby="cancel-heading">
        <h2 id="cancel-heading">Cancel subscription</h2>
        <p>Your plan remains active until the end of the current billing period.</p>
        <button type="button" onClick={props.onCancelAtPeriodEnd}>
          Cancel subscription at period end
        </button>
      </section>
    </main>
  );
}
