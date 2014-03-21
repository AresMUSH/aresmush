module AresMUSH

  module Describe
    class RoomRenderer
      def initialize(header_template, char_template, exit_template, footer_template)
        @header_template = header_template
        @char_template = char_template
        @exit_template = exit_template
        @footer_template = footer_template
      end

      def render(room)
        @room = room
        @data = RoomData.new(room)
        desc = build_header
        desc  << "\n"
        desc << build_chars
        desc  << "\n"
        desc << build_exits
        desc  << "\n"
        desc << build_footer
      end
            
      def build_header
        @header_template.render(@data)
      end
      
      def build_chars
        return t('describe.empty') if @room.clients.nil? || @room.clients.empty?
        
        contents_str = ""
        @room.clients.each do |c|
          char_data = CharData.new(c.char)
          contents_str << @char_template.render(char_data)
        end
        contents_str
      end

      def build_exits
        return t('describe.no_exits') if @room.exits.nil? || @room.exits.empty?

        contents_str = ""
        counter = 0
        @room.exits.each do |e|
          exit_data = ExitData.new(e)
          if (counter % 2 == 0)
            contents_str << "\n"
          end
          contents_str << @exit_template.render(exit_data).chomp
          counter = counter + 1
        end
        contents_str
      end

      def build_footer
        @footer_template.render(@data)
      end      
    end
  end
end