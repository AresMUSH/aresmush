module AresMUSH
  class RiMTalent < Ohm::Model
    include ObjectModel
#    include LearnableAbility

    reference :character, "AresMUSH::Character"
    attribute :name

    index :name

  end
end
