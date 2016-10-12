module AresMUSH
  class Character
    reference :last_ic_location, "AresMUSH::Room"

    attribute :afk_message
    attribute :is_afk, :type => DataType::Boolean
    attribute :is_on_duty, :type => DataType::Boolean, :default => true
    attribute :is_playerbit, :type => DataType::Boolean
  end
end