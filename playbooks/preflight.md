# Builder preflight

For an agent about to write code. Ten questions, asked before the first edit and re-asked before the commit. Each is a lens a mithril reviewer applies to your diff later, so a "no" here is a finding you avoid. Detail and sources live in the named skill; this page keeps no second copy of the rules.

Repo-local conventions, linters, and formatters always win over anything here. If the repo says otherwise, follow the repo.

1. **Necessary?** Name the nearest existing config, flag, helper, or framework hook and say why it cannot do this. (`review`, `GEP-LF`, `PP-2`)
2. **Intent?** State the behavior you must produce and what must stay unchanged, from the ticket or examples, not from the code you are about to change. (`review`)
3. **Blast radius?** If you change a default, a fallback, or newly gate unconditional code: grep the other callers, orgs, and tenants and say what each gets when the value is absent. (`review`)
4. **Smaller?** One reason to change per commit; refactor and behavior apart; speculative parameters and hooks left out. (`smells`, `GEP-CL`)
5. **Names and reuse?** Does a helper already do this? Will a reader trip on a name, a long function, or a duplicated decision? (`code-quality`, `smells`)
6. **Failure path?** What happens on empty, null, timeout, and partial failure; no swallowed errors. (`code-quality`, `flow`)
7. **Input to sink?** Does untrusted input reach a query, path, or command; what does each helper actually return? (`flow`, `security-review`)
8. **Test that can fail?** Write the test with the code; would it fail if the behavior broke, and survive a safe refactor? (`test-quality`)
9. **Shared state?** Concurrency, queries in a loop, a migration, a deploy ordering: only if the change touches them, then read that skill. (`concurrency`, `persistence`, `delivery`)
10. **Comments true?** If the change moves a count, name, or ordering, grep the docs for the old value. (`review`, `APOSD-12/13`)

Short ids resolve in `Resources/README.md`. For the always-on rules behind these, see `CONSTITUTION.md`.
