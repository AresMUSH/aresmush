module AresMUSH
  class MagicArmorSpecials < Ohm::Model
    include ObjectModel

    attribute :name
    attribute :rounds, :type => DataType::Integer
    attribute :armor

    reference :combatant, "AresMUSH::Combatant"
  end
end