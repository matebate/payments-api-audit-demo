# payments-api (audit-trail demo)

A deliberately tiny repository used to demonstrate **audit trails for AI coding agents**: proving,
from records, what an agent did on a change and who approved it.

It is a stage set, not an application. One function, one bug, one poisoned file, so every control
is visible on its own:

- **`docs/CONTRIBUTING.md`** contains a deliberate prompt injection asking an agent to send
  `~/.aws/credentials` to `attacker.example`. That domain is reserved and never resolves.
- **PR "PAY-1234: Fix refund rounding"** is a real Claude Code commit. It carries `Ticket` and
  `Agent-Session` trailers that link it to the agent's session record; the provenance gate passes.
- **PR "Quick tweak (no ticket)"** has no ticket trailer; the gate fails it.
- **Branch protection** requires the gate and one approval from someone other than the author,
  so even the passing PR stays blocked until a second person reviews it.

The provenance gate (`.github/workflows/provenance-gate.yml`) checks the PR head commit, not
GitHub's merge commit, and loads its script from the base branch so a PR cannot weaken its own check.
