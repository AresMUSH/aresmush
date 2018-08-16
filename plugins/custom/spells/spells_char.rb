module AresMUSH
  class Character < Ohm::Model
    collection :spells_learned, "AresMUSH::SpellsLearned"
  end
end

class SpellsLearned < Ohm::Model
  include ObjectModel

  attribute :name
  index :name
  attribute :last_learned
  reference :character, "AresMUSH::Character"
  attribute :level
  attribute :xp_needed
  attribute :learning_complete

end
