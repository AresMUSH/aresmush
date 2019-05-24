module AresMUSH
  class ConsoleAbility < Ohm::Model
    include ObjectModel
    include LearnableStat

    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 0
    attribute :acquired, :type => DataType::Integer, :default => 0
    attribute :masterpoints, :type => DataType::Integer, :default => 0
    attribute :learnpoints, :type => DataType::Integer, :default => 0
    attribute :learnable, :type => DataType::Boolean, :default => true
    attribute :learned, :type => DataType::Boolean, :default => false

    index :acquired
    index :name
  end
end
