# Pair C verification

Pair C covers Attendee, Ticket, and the Festival-to-Ticket relationship. The chosen policy is to prevent deletion of either parent while tickets exist. Festival declares the ticket restriction before Pair A's `dependent: :destroy` stage association, so a blocked deletion never deletes stages, including inside an outer transaction. A successful Festival deletion still removes its stages.

## Run the checks

Prepare a disposable test database with the prerequisite Festival and Stage tables and the Pair C migrations. This run used migrations through Ticket:

```bash
RAILS_ENV=test bin/rails db:migrate VERSION=20260101000600
RAILS_ENV=test bin/rails runner script/verify_pair_c.rb
bin/rails routes -g tickets
```

Use the version-targeted migration command only for a test database without newer applied migrations. After all seven migrations are implemented, use `RAILS_ENV=test bin/rails db:migrate` instead.

The script checks:

- Both Ticket foreign key declarations.
- `ticket.attendee`, `ticket.festival`, `attendee.tickets`, and `festival.tickets`.
- Required attendee fields and ticket tier, integer nonnegative prices, and free tickets.
- Parent deletion restrictions while tickets exist.
- Preservation of stages when a Festival deletion is blocked.
- Successful parent deletion after its tickets are removed, including Pair A's stage destruction.
- Both ticket listing routes and their controller/action mappings.
- Unchanged record counts after verification data is rolled back.

`console_transcript.txt` contains actual runner output, rather than a fabricated interactive console session. No controllers are required for these model and route-structure checks.

## Whole-team delivery

This is Pair C evidence, not a claim that the seven-table integration is finished. Once Performance and its associations/routes are implemented, regenerate the final schema with all migrations, run `bin/rails festival:check`, complete the remaining reflection sections, and run `bin/deliverables` to collect the final submission.
