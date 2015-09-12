module AresMUSH
  module Groups
    class CensusTemplate
      include TemplateFormatters
            
      attr_accessor :char
      
      def initialize(char)
        @char = char
      end
      
      def display
        "#{name} #{gender} #{position}"
      end
      
      def name
        left(@char.name, 20)
      end
      
      def gender
        left(@char.gender, 15)
      end
      
      def position
        @char.groups["Position"]
      end
    end
  end
end
