module AresMUSH
  class FS3Spell < Ohm::Model
    include ObjectModel
    include LearnableSpellAbility

    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 0

    index :rating
    index :name
  end
end
