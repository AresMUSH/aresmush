module AresMUSH
  class Character
    attribute :profile, :type => DataType::Hash, :default => {}   
    attribute :relationships, :type => DataType::Hash, :default => {}   
  end
end