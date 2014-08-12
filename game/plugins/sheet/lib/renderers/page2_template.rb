module AresMUSH
  module Sheet
    class SheetPage2Template
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
      end
      
      def name
        @char.name
      end
    end
  end
end