module AresMUSH
  module Describe
    # Template for a character.
    class CharacterTemplate
      include TemplateFormatters
      
      def initialize(char, client)
        @char = char
      end
      
      def display
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
        @char.rank
      end
      
      # Fullname, with rank if set (e.g. Commander William Adama)
      def fullname_and_rank
        @char.rank.nil? ? @char.fullname : "#{@char.rank} #{@char.fullname}"
      end
      
      # Fullname with rank and callsign, if set.  (e.g. Commander William "Husker" Adama)
      def military_name
        return "" if !@char.fullname
        first_name = @char.fullname.first(" ")
        last_name = @char.fullname.rest(" ")
        rank = @char.rank ? "#{@char.rank} " : ""
        callsign = @char.callsign ? "\"#{@char.callsign}\" " : ""
        "#{rank}#{first_name} #{callsign}#{last_name}"
      end
      
      def fullname
        @char.fullname
      end
      
      def actor
        "%xh#{t('describe.played_by')}%xn #{@char.actor}"
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