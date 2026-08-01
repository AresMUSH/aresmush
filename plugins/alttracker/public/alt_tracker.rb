module AresMUSH
  class AltTrackerRecord < Ohm::Model
    attribute :player_email
    index :player_email

    attribute :banned, :type => AresMUSH::DataType::Boolean, :default => false

    # nil = permanent ban; otherwise a Time when the ban ends
    attribute :ban_expires, :type => AresMUSH::DataType::Time

    # Array of ban/unban events (oldest → newest)
    attribute :ban_history, :type => AresMUSH::DataType::Array, :default => []

    attribute :code_word

    collection :characters, "AresMUSH::Character"
  end
end
