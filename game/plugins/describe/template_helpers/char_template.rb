module AresMUSH
  module Describe
    # Template for a character.
    class CharacterTemplate
      include TemplateFormatters
      
      def initialize(client)
        @client = client
        @char = client.char
      end
      
      # MUSH name.
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
      
      def fullname
        @char.fullname
      end
      
      # Actor name
      def actor
        @char.actor
      end
    end
  end
end