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
  attribute :level, :type => DataType::Integer
  attribute :xp_needed, :type => DataType::Integer
  attribute :learning_complete, :type => DataType::Boolean
  attribute :school

end
