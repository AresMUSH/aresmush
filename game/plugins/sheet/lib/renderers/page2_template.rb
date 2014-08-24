module AresMUSH
  module Sheet
    class SheetPage2Template
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
      end
      
      def name
        left(@char.name, 25)
      end
      
      def approval_status
        status = @char.is_approved ? 
        "%xg%xh#{t('sheet.approved')}%xn" : 
        "%xr%xh#{t('sheet.unapproved')}%xn"
        center(status, 32)
      end
      
      def page_title
        right(t('sheet.page2_title'), 28)
      end
      
    end
  end
end