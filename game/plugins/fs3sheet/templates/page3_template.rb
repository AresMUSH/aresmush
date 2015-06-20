module AresMUSH
  module Sheet
    class SheetPage3Template
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
      end
      
      def display
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
        status = @char.is_approved ? 
        "%xg%xh#{t('sheet.approved')}%xn" : 
        "%xr%xh#{t('sheet.unapproved')}%xn"
        center(status, 23)
      end
      
      def page_title
        right(t('sheet.bg_page_title'), 28)
      end
      
      def background
        @char.background
      end
    end
  end
end