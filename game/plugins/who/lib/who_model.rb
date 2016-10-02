module AresMUSH
  class Game
    attribute :online_record, DataType::Integer    
          
    def self.online_record
      Game.master.online_record
    end
    
    def self.online_record=(value)
      game = Game.master
      game.online_record = value
      game.save
    end    
  end
  
  class Character
    attribute :hidden, DataType::Boolean
  end
  
end