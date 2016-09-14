module AresMUSH
  class Character
    
    def ooc_name
      if (self.handle?)
        display_name = "#{self.name} (@#{self.handle})"
      else
        display_name = self.name
      end
      
      return display_name
    end
    
  end
end