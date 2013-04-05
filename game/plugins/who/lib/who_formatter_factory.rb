module AresMUSH
  module Who
    class WhoFormatterFactory
      def self.build_char_formatter(client, container)
        # TOOD - get the class to use from config
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