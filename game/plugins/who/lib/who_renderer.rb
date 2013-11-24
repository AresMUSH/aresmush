module AresMUSH
  module Who
    class WhoRenderer
      def self.render(clients)
        who_list = build_header(clients)
        who_list << "\n" << build_chars(clients)
        who_list << "\n" << build_footer(clients)
      end
      
      def self.build_header(clients)
        header = WhoRendererFactory.build_header(clients)
        header.render
      end
      
      def self.build_footer(clients)
        footer = WhoRendererFactory.build_footer(clients)        
        footer.render
      end
            
      def self.build_chars(clients)
        chars = []
        who_list = ""
        clients.each do |c| 
          formatter = WhoRendererFactory.build_char(c)
          who_list << formatter.render
        end  
        who_list            
      end
    end
  end
end