module AresMUSH

  class MagicShields < Ohm::Model
    include ObjectModel

    attribute :name
    attribute :rounds, :type => DataType::Integer
    attribute :strength, :type => DataType::Integer

    reference :character, "AresMUSH::Character"
    reference :npc, "AresMUSH::Npc"

    def shields_against
      Global.read_config("spells", self.name, "shields_against")
    end

  end
end
