module AresMUSH
  module Who
    class WhoFormatterFactory
      # TOOD - get the class to use from config
      def self.build_char_formatter(client, container)
        WhoCharFormatter.new(client, container)
      end
      
      def self.build_header_formatter(clients, container)
        WhoHeaderFormatter.new(clients, container)
      end
      
      def self.build_footer_formatter(clients, container)
        WhoFooterFormatter.new(clients, container)
      end
    end
  end
end