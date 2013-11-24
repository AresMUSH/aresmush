module AresMUSH
  module Who
    class WhoRendererFactory
      # TOOD - get the class to use from config
      def self.build_char(client)
        WhoChar.new(client)
      end
      
      def self.build_header(clients)
        WhoHeader.new(clients)
      end
      
      def self.build_footer(clients)
        WhoFooter.new(clients)
      end
    end    
  end
end