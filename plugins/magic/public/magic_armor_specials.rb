module AresMUSH
  class MagicArmorSpecials < Ohm::Model
    include ObjectModel

    attribute :name
    attribute :rounds, :type => DataType::Integer
    attribute :armor

    reference :character, "AresMUSH::Character"
    reference :npc, "AresMUSH::Npc"


  end
end