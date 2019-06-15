module AresMUSH
  module CharDescTemplateFields

    def rank(char)
      char.rank
    end
    
    # Fullname with rank and callsign, if set.  (e.g. Commander William "Husker" Adama)
    def military_name(char)
      Ranks.military_name(char)
    end
    
    def actor(char)
      char.demographic(:actor)
    end
    
  end
end