# Pair C verification

Pair C covers Attendee, Ticket, and the Festival-to-Ticket relationship. The chosen policy is to prevent deletion of either parent while tickets exist. Festival declares the ticket restriction before Pair A's `dependent: :destroy` stage association, so a blocked deletion never deletes stages, including inside an outer transaction. A successful Festival deletion still removes its stages.

## Run the checks

Prepare a disposable test database using all seven migrations, including the integrated Performance migration:

```bash
RAILS_ENV=test bin/rails db:migrate
RAILS_ENV=test bin/rails runner script/verify_pair_c.rb
RAILS_ENV=test bin/rails routes -g tickets
RAILS_ENV=test bin/rails festival:check
```

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

The captured run uses the integrated seven-table schema. The full structural self-check passes all 45 checks, and the Pair C runner passes all 18 checks. Complete the remaining team reflection sections and run `bin/deliverables` to collect the final submission. These structural and Pair C checks do not replace the team's discussion or its final review of the deliverables.
