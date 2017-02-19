module AresMUSH
  module Chargen
    class BgTemplate < ErbTemplateRenderer
      
      attr_accessor :char, :background
      
      def initialize(char, background)
        @char = char
        @background = background
        super File.dirname(__FILE__) + "/bg.erb" 
      end
            
      def approval_status
        Chargen.approval_status(@char)
      end
    end
  end
end