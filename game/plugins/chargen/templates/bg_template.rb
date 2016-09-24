module AresMUSH
  module Chargen
    class BgTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/bg.erb" 
      end
            
      def approval_status
        Chargen.approval_status(@char)
      end
    end
  end
end