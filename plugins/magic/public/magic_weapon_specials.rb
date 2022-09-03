module AresMUSH
  class MagicWeaponSpecials < Ohm::Model
    include ObjectModel
    attribute :name
    attribute :rounds, :type => DataType::Integer
    attribute :weapon

    reference :combatant, "AresMUSH::Combatant"


  end
end