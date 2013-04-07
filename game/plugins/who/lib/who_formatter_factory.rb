module AresMUSH
  module Who
    class WhoFormatterFactory
      # TOOD - get the class to use from config
      def self.build_char(client, container)
        WhoChar.new(client, container)
      end
      
      def self.build_header(clients, container)
        WhoHeader.new(clients, container)
      end
      
      def self.build_footer(clients, container)
        WhoFooter.new(clients, container)
      end
    end    
  end
end