module AresMUSH
  module Who
    class WhoRenderer
      def initialize(clients, header_template, char_template, footer_template)
        @clients = clients
        @header_template = header_template
        @char_template = char_template
        @footer_template = footer_template
        @data = WhoData.new(clients)
      end
      
      def render
        who_list = build_header
        who_list << build_chars
        who_list << build_footer
      end
      
      def build_header
        @header_template.render(@data)
      end
      
      def build_footer
        @footer_template.render(@data)
      end
            
      def build_chars
        char_text = ""
        @clients.each do |c| 
          data = WhoCharData.new(c)
          char_text << "\n" << @char_template.render(data)
        end
        char_text << "\n"
        char_text     
      end
    end
  end
end