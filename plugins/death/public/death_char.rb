module AresMUSH
  class Character< Ohm::Model

    include ObjectModel
    attribute :dead, :type => DataType::Boolean, :default => false
    attribute :has_died, :type => DataType::Integer
  end
end
