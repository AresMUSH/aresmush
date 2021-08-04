module AresMUSH
  class Combatant< Ohm::Model

    include ObjectModel
    attribute :death_count, :type => DataType::Integer, :default => 0

  end
end
