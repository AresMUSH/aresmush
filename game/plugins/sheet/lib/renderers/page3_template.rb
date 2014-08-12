module AresMUSH
  module Sheet
    class SheetPage3Template
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
      end
      
      def name
        @char.name
      end
      
      def background
        # TODO
        "My%rvery%rlong%rbackground"
      end
    end
  end
end