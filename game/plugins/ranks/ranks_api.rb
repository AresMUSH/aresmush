module AresMUSH
  class Character
    def rank
      self.ranks_rank
    end
  end
  
  
  module Ranks
    
    module Api
      def self.app_review(char)
        Ranks.app_review(char)
      end
      
      def self.military_name(char)
        fullname = char.demographic(:fullname) || char.name
        first_name = fullname.first(" ")
        last_name = fullname.rest(" ")
        rank_str = char.rank ? "#{char.rank} " : ""
        callsign = char.demographic(:callsign)
        callsign_str =  callsign ? "\"#{callsign}\" " : ""
        "#{rank_str}#{first_name} #{callsign_str}#{last_name}"
      end
    end
  end
end