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
  # Q: URL to list one artist's tracks (children)?  GET /artists/:artist_id/tracks
  # Q: The Param holding the parent's id?    :artist_id (on nested routes only)
  # Q: What changed in the output when you used shallow: true?
  #    index/create stay nested under /artists/:artist_id/tracks;
  #    show/update/destroy moved to /tracks/:id. (No new/edit routes because
  #    the app is api_only.) A track's id already identifies it, so the
  #    artist id is only needed to list an artist's tracks or create a new one.    
  resources :artists, shallow: true do
    resources :tracks
  end


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
  resources :stages, only: [] do
    resources :performances
  end

  resources :artists, only: [] do
    resources :performances
  end


end
