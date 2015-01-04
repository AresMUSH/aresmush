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
  end
  
end