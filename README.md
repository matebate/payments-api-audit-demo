# payments-api (audit-trail demo)

Demo repository for the "sixth layer" article: proving what an AI coding agent did.
`docs/CONTRIBUTING.md` contains a deliberate prompt injection used in the demo; the
attacker domain (`attacker.example`) is reserved and never resolves.

- PR `feature/PAY-1234-fix-refund-rounding`: agent commit with Ticket and Agent-Session trailers.
- PR `quickfix`: commit with no ticket, so the provenance gate fails.
