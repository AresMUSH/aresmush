module AresMUSH
  module Describe
    # Template for a character.
    class CharacterTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :char 
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/character.erb"        
      end
            
      def rank
        Ranks::Api.rank(@char)
      end
      
      # Fullname, with rank if set (e.g. Commander William Adama)
      def fullname_and_rank
        !rank ? fullname : "#{rank} #{fullname}"
      end
      
      def callsign
        Demographics::Api.demographic(@char, :callsign)
      end
      
      # Fullname with rank and callsign, if set.  (e.g. Commander William "Husker" Adama)
      def military_name
        return "" if !fullname
        first_name = fullname.first(" ")
        last_name = fullname.rest(" ")
        rank_str = rank ? "#{rank} " : ""
        callsign_str =  callsign ? "\"#{callsign}\" " : ""
        "#{rank_str}#{first_name} #{callsign_str}#{last_name}"
      end
      
      def fullname
        Demographics::Api.demographic(@char, :fullname)
      end
      
      def actor
        @char.actor
      end
      
      def details
        names = @char.details.map { |d| d.name }
        names.empty? ? nil : names.sort.join(", ")
      end
    end
  end
end