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
    field :hidden, :type => Boolean
        
    def is_ic?
      self.room.room_type == "IC"
    end

    def faction
      "A Faction"
    end
    
    def position
      "Up"
    end
    
    def who_room_name
      area = self.room.area.nil? ? "" : "#{self.room.area} - "
      self.hidden ? t('who.hidden') : "#{area}#{self.room.name}"
    end
  end
  
end