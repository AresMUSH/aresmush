module AresMUSH
  module Who
    class WhoFormatter
      def self.format(clients, container)
        who_list = build_header(clients, container)
        who_list << "\n" << build_chars(clients, container)
        who_list << "\n" << build_footer(clients, container)
      end
      
      def self.build_header(clients, container)
        header = WhoFormatterFactory.build_header(clients, container)
        header.render
      end
      
      def self.build_footer(clients, container)
        footer = WhoFormatterFactory.build_footer(clients, container)        
        footer.render
      end
            
      def self.build_chars(clients, container)
        chars = []
        who_list = ""
        clients.each do |c| 
          formatter = WhoFormatterFactory.build_char(c, container)
          who_list << formatter.render
        end  
        who_list            
      end
    end
  end
end