module AresMUSH
  module Who
    class WhoFormatter
      def self.format(clients, container)
        who_list = build_header(clients, container)
        who_list << build_chars(clients, container)
        who_list << build_footer(clients, container)
      end
      
      def self.build_header(clients, container)
        header = WhoFormatterFactory.build_header_formatter(clients, container)
        header.render_default
      end
      
      def self.build_footer(clients, container)
        footer = WhoFormatterFactory.build_footer_formatter(clients, container)        
        footer.render_default
      end
            
      def self.build_chars(clients, container)
        chars = []
        who_list = ""
        clients.each do |c| 
          formatter = WhoFormatterFactory.build_char_formatter(c, container)
          who_list << formatter.render_default
        end  
        who_list            
      end
    end
  end
end