module AresMUSH
  class MSkill < Ohm::Model
    include ObjectModel
    include LearnableAbility

    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :type
    attribute :base, :type => DataType::Integer, :default => 0
    attribute :rating, :type => DataType::Integer, :default => 0

    index :name

    def total
      base + rating
    end
  end
end