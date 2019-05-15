module AresMUSH
  class FS3Spell < Ohm::Model
    include ObjectModel
    include LearnableAbility

    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :level, :type => DataType::Integer, :default => 0

    index :level
    index :name
  end
end
