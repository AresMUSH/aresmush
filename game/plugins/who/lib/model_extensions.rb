module AresMUSH
  class Game
    key :online_record, Integer    
    
    before_create :initialize_who_record
      
    def initialize_who_record
      Global.logger.debug "Initializing who record."
      @online_record = 0
    end
  end
  
  # TODO: Really belongs somewhere else - status module maybe?
  #class Character
  #  key :status, String
  #  
  #  def is_ic?
  #    :status == "IC"
  #  end
  #end
  
end