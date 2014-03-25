module AresMUSH
  module Describe
    class CharData
      include TemplateFormatters
      
      def initialize(char)
        @char = char
      end
      
      def name
        @char.name
      end
      
      def description
        @char.description
      end
      
      def shortdesc
        @char.shortdesc.nil? ? "" : "- #{@char.shortdesc}"
      end
    end
  end
end