module AresMUSH
  module CharDescTemplateFields

    def rank(char)
      char.rank
    end
    
    # Fullname, with rank if set (e.g. Commander William Adama)
    def fullname_and_rank(char)
      !rank(char) ? fullname(char) : "#{rank(char)} #{fullname(char)}"
    end
    
    def callsign(char)
      char.demographic(:callsign)
    end
    
    # Fullname with rank and callsign, if set.  (e.g. Commander William "Husker" Adama)
    def military_name(char)
      Ranks.military_name(char)
    end
    
    def fullname(char)
      char.demographic(:fullname) || char.name
    end
    
    def actor(char)
      char.actor
    end
    
  end
end