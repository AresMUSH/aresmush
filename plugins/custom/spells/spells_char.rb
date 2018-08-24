module AresMUSH
  class Character < Ohm::Model
    collection :spells_learned, "AresMUSH::SpellsLearned"
  end
end

class SpellsLearned < Ohm::Model
  include ObjectModel


  attribute :name
  index :name
  attribute :last_learned, :type => Ohm::DataTypes::DataType::Time, :default => Time.now
  reference :character, "AresMUSH::Character"
  attribute :level, :type => DataType::Integer
  attribute :xp_needed, :type => DataType::Integer
  attribute :learning_complete, :type => DataType::Boolean
  attribute :school
  attribute :time_to_next_learn_spell

  def can_learn?
    self.time_to_next_learn <= 0
  end

  def time_to_next_learn
    return 0 if !self.last_learned
    time_left = (FS3Skills.days_between_learning * 86400) - (Time.now - self.last_learned)
    [time_left, 0].max
  end

end
