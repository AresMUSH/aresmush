module AresMUSH
  module Describe
    # Template for a character.
    class CharacterTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      def initialize(char, client)
        @char = char
        super client
      end
      
      def build
        text = "%l1%r"
        text << "%xh%xg#{name}%xn (#{military_name})%r"
        text << "%r"
        text << "#{description}#{details}%r"
        text << "%r"
        text << "#{actor}%r"
        text << "%l1"
        
        text
      end
        
      def name
        @char.name
      end
      
      def description
        @char.description
      end
      
      def shortdesc
        @char.shortdesc
      end
      
      def rank
        Ranks::Api.rank(@char)
      end
      
      # Fullname, with rank if set (e.g. Commander William Adama)
      def fullname_and_rank
        rank.nil? ? fullname : "#{rank} #{fullname}"
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
        callsign_str =  callsign ? "\"#{@char.callsign}\" " : ""
        "#{rank_str}#{first_name} #{callsign_str}#{last_name}"
      end
      
      def fullname
        Demographics::Api.fullname(@char)
      end
      
      def actor
        "%xh#{t('describe.played_by')}%xn #{Actors::Api.get_actor(@char)}"
      end
      
      # Available detail views.
      def details
        names = @char.details.keys
        return "" if names.empty?
        "%R%R%xh#{t('describe.details_available')}%xn #{names.sort.join(", ")}"
      end
    end
  end
end