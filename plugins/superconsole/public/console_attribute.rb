module AresMUSH
  class ConsoleAttribute < Ohm::Model
    include ObjectModel

    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 1
    attribute :favored, :type => DataType::Boolean, :default => false
    attribute :unfavored, :type => DataType::Boolean, :default => false

    index :name
  end
end
