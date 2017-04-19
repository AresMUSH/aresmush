module AresMUSH
  class Character

    attribute :birthdate, :type => DataType::Date
    attribute :demographics, :type => DataType::Hash, :default => {}
    attribute :groups, :type => DataType::Hash, :default => {}
  end
  
end