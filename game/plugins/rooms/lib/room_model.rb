module AresMUSH
  class Character
    before_create :set_starting_room
    
    def set_starting_room
      Global.logger.debug "Setting starting room."
      
      self.room = Game.master.welcome_room
    end
  end
  
  class Room      
    before_destroy :null_out_sources
     
    def null_out_sources
      sources = Exit.where(:dest_id => self.id)
      sources.each do |s|
        s.dest = nil
        s.save!
      end
    end
  end
end