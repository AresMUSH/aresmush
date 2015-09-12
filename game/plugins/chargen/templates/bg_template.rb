module AresMUSH
  module Chargen
    class BgTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char, client)
        @char = char
        super client
      end
      
      def build
        text = "%l1%r"
        text << "%xh#{name}%xn #{approval_status} #{page_title}%r"
        text << "%l2%r"
        text << "#{background}%r"
        text << "%l1"
        
        text
      end
      
      def name
        left(@char.name, 25)
      end
      
      def approval_status
        status = Chargen.approval_status(@char)
        center(status, 23)
      end
      
      def page_title
        right(t('chargen.bg_page_title'), 28)
      end
      
      def background
        @char.background
      end
    end
  end
end