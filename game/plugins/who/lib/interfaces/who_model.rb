module AresMUSH
  class Game
    field :online_record, :type => Integer    
    
    before_create :initialize_who_record
      
    def initialize_who_record
      Global.logger.debug "Initializing who record."
      self.online_record = 0
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
    field :status, :type => String
    field :hidden, :type => Boolean
    
    before_create :initialize_char
    
    def initialize_char
      self.status = "NEW"
    end
    
    def is_ic?
      self.status == "IC"
    end

    def faction
      "A Faction"
    end
    
    def position
      "Up"
    end
    
    def who_room_name
      self.hidden ? t('who.hidden') : self.room.name
    end
  end
  
end