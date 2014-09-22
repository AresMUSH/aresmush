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
  
  class Character
    field :hidden, :type => Boolean
            
    def who_room_name
      if (self.hidden)
        return t('who.hidden')
      end
      
      area = self.room.area.nil? ? "" : "#{self.room.area} - "
      "#{area}#{self.room.name}"
    end
  end
  
end