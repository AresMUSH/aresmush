module AresMUSH
  class Character
    attribute :idle_warned
    attribute :idle_lastwill
    attribute :idle_state
    attribute :roster_contact
    attribute :roster_notes
    attribute :roster_restricted, :type => DataType::Boolean
  end
end