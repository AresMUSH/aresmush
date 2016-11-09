module AresMUSH
  module Describe
    # Template for a character.
    class CharacterTemplate < ErbTemplateRenderer
      include TemplateFormatters
      include CharDescTemplateFields
      
      attr_accessor :char 
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/character.erb"        
      end
            
      def details
        names = @char.details.map { |d| d.name }
        names.empty? ? nil : names.sort.join(", ")
      end
    end
  end
end