Rails.application.routes.draw do
  # Phases 3 and 4: add your nested routes in YOUR section only.
  # Staying inside your own section keeps merge conflicts small.
  # Check your work with:  bin/rails routes | grep <resource>


  # ---------- Pair A: Festival -> Stage ----------



  # ---------- Pair B: Artist -> Track (use shallow nesting) ----------



  # ---------- Pair C: Attendee -> Ticket (and Festival -> Ticket) ----------
  # /attendees/:attendee_id/tickets lists an attendee's purchase history;
  # :attendee_id identifies that attendee.
  # /festivals/:festival_id/tickets lists a festival's ticket sales;
  # :festival_id identifies that festival.

  resources :attendees do
    resources :tickets
  end

  resources :festivals, only: [] do
    resources :tickets
  end


  # ---------- Integrator: Stage / Artist -> Performance ----------



end
