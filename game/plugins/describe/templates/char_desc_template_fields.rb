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
      fullname = fullname(char)
      return "" if !fullname
      first_name = fullname.first(" ")
      last_name = fullname.rest(" ")
      rank_str = rank(char) ? "#{rank(char)} " : ""
      callsign_str =  callsign(char) ? "\"#{callsign(char)}\" " : ""
      "#{rank_str}#{first_name} #{callsign_str}#{last_name}"
    end
    
    def fullname(char)
      char.demographic(:fullname) || char.name
    end
    
    def actor(char)
      char.actor
    end
    
  end
end