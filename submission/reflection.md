# Reflection answers

Team: 
Members: 

**a. In each relationship, which table holds the foreign key, and why that table?**

For Pair C, tickets holds both attendee_id and festival_id. Each ticket belongs to one attendee and one festival, while either parent can have many tickets. Storing the references on tickets represents both one-to-many relationships without putting lists of ticket IDs on either parent. The migration creates both database foreign keys, Ticket declares both belongs_to associations, and Attendee and Festival each declare has_many :tickets.

**b. What happens to a Festival's Stages when the Festival is destroyed? Where in your code did you specify that behavior?**

Festival declares has_many :stages, dependent: :destroy in app/models/festival.rb. It first declares has_many :tickets, dependent: :restrict_with_error, so the ticket restriction is checked before stage destruction callbacks. A festival with tickets cannot be destroyed, and its stages remain untouched even when the caller has an outer transaction. Once no tickets remain, destroying the festival also destroys its stages. This preserves Pair A's stage ownership behavior while preventing accidental removal of ticket history.

**c. Why does `Performance` need to be its own model with its own table, rather than a bare join table with no model?**



**Bonus (Pair B): what changed in `rails routes` when you used `shallow: true`?**



**Bonus (Pair C): why might tickets be nested under both Attendee and Festival?**

GET /attendees/:attendee_id/tickets lists one attendee's purchase history, using attendee_id as the parent parameter. GET /festivals/:festival_id/tickets lists one festival's ticket sales, using festival_id as the parent parameter. Both routes access the same Ticket model and tickets table from different parent contexts. Their member routes additionally use id to identify the ticket. Pair C uses resources :festivals, only: [] so it adds ticket routes without duplicating Pair A's Festival CRUD routes.

## Pair C verification

Pair C contributors: Keith Wang and Junxiao Wang.

Run RAILS_ENV=test bin/rails runner script/verify_pair_c.rb against a migrated test database. The script checks both foreign keys, all four directions of the parent-ticket relationships, model validations, both route contexts, and deletion restrictions. It also verifies inside an outer transaction that a blocked Festival destruction preserves its stages, and that a festival without tickets retains Pair A's dependent stage destruction. All verification records are rolled back. The captured execution is in submission/console_transcript.txt; reproduction instructions are in submission/pair_c_verification.md.
