Rails.application.routes.draw do
  # Phases 3 and 4: add your nested routes in YOUR section only.
  # Staying inside your own section keeps merge conflicts small.
  # Check your work with:  bin/rails routes | grep <resource>


  # ---------- Pair A: Festival -> Stage ----------
  # Q: What URL path lists the children of one parent?
  # A: /festivals/:festival_id/stages (e.g. /festivals/1/stages).
  # Q: Which route parameter holds the parent's id?
  # A: :festival_id. The stage's own id is :id.
  resources :festivals do
    resources :stages
  end


  # ---------- Pair B: Artist -> Track (use shallow nesting) ----------



  # ---------- Pair C: Attendee -> Ticket (and Festival -> Ticket) ----------



  # ---------- Integrator: Stage / Artist -> Performance ----------



end
