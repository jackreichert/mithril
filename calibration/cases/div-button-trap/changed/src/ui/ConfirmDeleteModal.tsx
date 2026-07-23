import React from "react";

/**
 * SEEDED DEFECT 1 (div button): primary action is a div with onClick only —
 * no role, no tabIndex, no keyboard handler, no accessible name beyond visual text
 * that is not exposed if CSS hides it... actually text is there but role is missing.
 *
 * SEEDED DEFECT 2 (focus trap): modal captures focus conceptually but provides
 * no Escape handler and no return-focus path; overlay click does nothing for keyboard users.
 */
export function ConfirmDeleteModal(props: {
  open: boolean;
  onConfirm: () => void;
  onClose: () => void;
}) {
  if (!props.open) return null;

  return (
    <div className="modal-overlay">
      <div className="modal-panel">
        <h2>Delete item?</h2>
        <p>This cannot be undone.</p>
        {/* SEEDED: not a real button */}
        <div className="btn-primary" onClick={props.onConfirm}>
          Delete
        </div>
        {/* SEEDED: cancel also mouse-only div */}
        <div className="btn-secondary" onClick={props.onClose}>
          Cancel
        </div>
      </div>
    </div>
  );
}
