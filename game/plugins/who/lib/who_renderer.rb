module AresMUSH
  module Who
    class WhoRenderer
      def initialize(header_template, char_template, footer_template)
        @header_template = header_template
        @char_template = char_template
        @footer_template = footer_template
      end
      
      def render(clients)
        data = WhoData.new(clients)
        who_list = build_header(data)
        who_list << build_chars(data)
        who_list << build_footer(data)
      end
      
      def build_header(data)
        @header_template.render(data)
      end
      
      def build_footer(data)
        @footer_template.render(data)
      end
            
      def build_chars(data)
        char_text = ""
        data.clients.each do |c| 
          data = WhoCharData.new(c)
          char_text << "\n" << @char_template.render(data)
        end
        char_text << "\n"
        char_text     
      end
    end
  end
end