module AresMUSH
    module Txt 
      
      def self.format_txt_indicator(char, names)
        t('txt.txt_indicator',
#        :start_marker => Global.read_config("page", "page_start_marker") || "<",
#        :end_marker => Global.read_config("page", "page_end_marker") || "<",
        :start_marker => "(",
        :recipients => names,
        :end_marker => ")",
        :color => Txt.txt_color(char) )
      end
      
      def self.format_recipient_indicator(names)
        return t('txt.recipient_indicator', :recipients => names.join(" "))
      end

      def self.txt_color(char)
        char.txt_color || "%xh%xy"
      end

    end
end