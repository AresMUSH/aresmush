module AresMUSH
  module Describe
    # Template for a character.
    class CharacterTemplate < ErbTemplateRenderer
      include CharDescTemplateFields
      
      attr_accessor :char 
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/character.erb"        
      end
            
      def details
        names = @char.details.keys.sort
        names.empty? ? nil : names.join(", ")
      end
      
      def char_name
        Demographics.name_and_nickname(@char)
      end
    end
  end
end