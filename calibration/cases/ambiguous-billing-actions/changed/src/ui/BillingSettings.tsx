import React from "react";

export function BillingSettings(props: {
  accountName: string;
  onSave: (accountName: string) => Promise<void>;
  onCancelNow: () => void;
}) {
  const [accountName, setAccountName] = React.useState(props.accountName);

  async function saveBillingProfile(event: React.FormEvent) {
    event.preventDefault();
    // SEEDED DEFECT: no pending, success, or failure feedback while saving.
    await props.onSave(accountName);
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
        <button type="submit">Continue</button>
      </form>

      <section aria-labelledby="options-heading">
        <h2 id="options-heading">Subscription options</h2>
        <p>Manage your subscription.</p>
        {/* SEEDED DEFECT: ambiguous label triggers immediate destructive action. */}
        <button type="button" onClick={props.onCancelNow}>
          Continue
        </button>
      </section>
    </main>
  );
}
