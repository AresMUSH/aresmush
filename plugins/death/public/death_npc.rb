module AresMUSH
  class Npc< Ohm::Model

    include ObjectModel

    attribute :dead, :type => DataType::Boolean, :default => false

  end
end
