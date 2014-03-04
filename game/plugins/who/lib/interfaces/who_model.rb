module AresMUSH
  class Game
    key :online_record, Integer    
    
    before_create :initialize_who_record
      
    def initialize_who_record
      Global.logger.debug "Initializing who record."
      @online_record = 0
    end
    
    def self.online_record
      Game.master.online_record
    end
    
    def self.online_record=(value)
      game = Game.master
      game.online_record = value
      game.save!
    end    
  end
  
  # TODO: All of this stuff belongs somewhere else.  Here just for testing.
  class Character
    key :status, String
    key :hidden, Boolean
    
    before_create :initialize_char
    
    def initialize_char
      @status = "NEW"
    end
    
    def is_ic?
      @status == "IC"
    end

    def faction
      "A Faction"
    end
    
    def position
      "Up"
    end
    
    def who_location
      self.room.name
    end
  end
  
end