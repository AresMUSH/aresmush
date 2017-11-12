module AresMUSH
  class Game
    attribute :online_record, :type => DataType::Integer    
  end
  
  class Character
    attribute :who_hidden, :type => DataType::Boolean
  end
  
end