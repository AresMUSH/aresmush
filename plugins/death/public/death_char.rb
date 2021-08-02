module AresMUSH
  class Character
    attribute :dead, :type => DataType::Boolean, :default => false
    attribute :has_died, :type => DataType::Integer
  end
end
