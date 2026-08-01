module AresMUSH
  class AltTrackerRecord < Ohm::Model
    attribute :player_email
    index :player_email

    # Stored as string; treat as boolean in helpers ("true"/"false"/nil)
    attribute :banned, :default => false

    # nil = permanent ban; otherwise a Time string when the ban ends
    attribute :ban_expires

    # Array of ban/unban events (oldest → newest). Ohm will serialize.
    attribute :ban_history, :default => []

    attribute :code_word

    collection :characters, "AresMUSH::Character"
  end
end
