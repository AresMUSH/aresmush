module AresMUSH
  class Character
    attribute :spell_mod, :type => DataType::Integer, :default => 0
    attribute :has_cast, :type => DataType::Boolean, :default => false
  end
end
