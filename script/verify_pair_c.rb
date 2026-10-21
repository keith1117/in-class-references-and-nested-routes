# Run with: RAILS_ENV=test bin/rails runner script/verify_pair_c.rb
# All verification records are rolled back, including after a failed check.

def check(description)
  raise "FAIL: #{description}" unless yield

  puts "PASS: #{description}"
end

puts "Pair C verification"
puts "Ruby #{RUBY_VERSION}; Rails #{Rails.version}; #{ActiveRecord::Base.connection.adapter_name}"

foreign_keys = ActiveRecord::Base.connection.foreign_keys(:tickets).map(&:to_table)
check("tickets has foreign keys to attendees and festivals") do
  %w[attendees festivals].all? { |parent| foreign_keys.include?(parent) }
end

models = [Festival, Stage, Attendee, Ticket]
initial_counts = models.map(&:count)

ActiveRecord::Base.transaction do
  festival = Festival.create!(name: "Pair C festival", starts_on: Date.current, city: "Austin")
  stage = festival.stages.create!(name: "Main Stage", capacity: 5000)
  attendee = Attendee.create!(name: "Pair C attendee", email: "pair-c@example.com")
  ticket = attendee.tickets.create!(festival: festival, tier: "general", price_cents: 2500)

  check("ticket.attendee returns its attendee") { ticket.attendee == attendee }
  check("ticket.festival returns its festival") { ticket.festival == festival }
  check("attendee.tickets includes the ticket") { attendee.tickets.include?(ticket) }
  check("festival.tickets includes the ticket") { festival.tickets.include?(ticket) }

  check("Attendee rejects missing name or email") do
    !Attendee.new(name: "", email: "pair-c@example.com").valid? &&
      !Attendee.new(name: "Pair C attendee", email: "").valid?
  end
  check("Ticket rejects a missing tier") do
    !Ticket.new(attendee: attendee, festival: festival, tier: "", price_cents: 2500).valid?
  end
  check("Ticket rejects missing, negative, fractional, and nonnumeric prices") do
    [nil, -1, 12.5, "12.5", "invalid"].all? do |price|
      !Ticket.new(attendee: attendee, festival: festival, tier: "general", price_cents: price).valid?
    end
  end
  check("Ticket allows a zero price") do
    Ticket.new(attendee: attendee, festival: festival, tier: "general", price_cents: 0).valid?
  end

  check("Attendee with tickets cannot be destroyed") { attendee.destroy == false }
  check("Festival with tickets cannot be destroyed") { festival.destroy == false }
  check("Blocked Festival deletion preserves the festival, stage, and ticket") do
    Festival.exists?(festival.id) && Stage.exists?(stage.id) && Ticket.exists?(ticket.id)
  end

  ticket.destroy!
  check("Festival without tickets can be destroyed") { festival.reload.destroy }
  check("Successful Festival deletion also destroys its stages") { !Stage.exists?(stage.id) }
  check("Attendee without tickets can be destroyed") { attendee.reload.destroy }

  raise ActiveRecord::Rollback
end

check("Verification leaves record counts unchanged") { models.map(&:count) == initial_counts }

routes = Rails.application.routes.routes.to_a
[
  "/attendees/:attendee_id/tickets(.:format)",
  "/festivals/:festival_id/tickets(.:format)"
].each do |path|
  check("GET #{path} maps to tickets#index") do
    routes.any? do |route|
      route.verb == "GET" && route.path.spec.to_s == path &&
        route.defaults[:controller] == "tickets" && route.defaults[:action] == "index"
    end
  end
end

puts "All Pair C checks passed. Verification records were rolled back."
