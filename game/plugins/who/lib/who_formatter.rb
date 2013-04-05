module AresMUSH
  module Who
    class WhoFormatter
      def self.format(clients, container)
        header = WhoFormatterFactory.build_header_formatter(clients, container)
        chars = []
        clients.each { |c| chars << WhoFormatterFactory.build_char_formatter(c, container) }
        footer = WhoFormatterFactory.build_footer_formatter(clients, container)        

        # TODO - add configurable sort to WhoCharFormatter
        who_list = header.render_default

        chars.each do |c|
          who_list << c.render_default
        end
        
        who_list << footer.render_default
      end
    end
  end
end