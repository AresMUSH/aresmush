module AresMUSH

  module Describe
    class RoomRenderer
      def initialize(room, desc_factory, container)
        @desc_factory = desc_factory
        @client_monitor = container.client_monitor
        @room = room
      end

      def render
        desc = build_header
        desc << build_room_char_header
        desc << build_chars
        desc << build_room_exit_header
        desc << build_exits
        desc << build_footer
      end
      
      # TODO - Need to refactor this so it's overrideable with custom renderers.
      
      def build_header
        renderer = @desc_factory.build_room_header(@room)
        renderer.render
      end
      
      def build_room_char_header
        renderer = @desc_factory.build_room_char_header(@room)
        renderer.render
      end
      
      def build_room_exit_header
        renderer = @desc_factory.build_room_exit_header(@room)
        renderer.render
      end
      
      def build_chars
        contents = @client_monitor.clients.select { |c| c.logged_in? && c.location == @room["_id"] }
        contents_str = ""
        contents.each do |c|
          renderer = @desc_factory.build_room_each_char(c.char)
          contents_str << renderer.render
        end
        contents_str
      end

      def build_exits
        contents = Exit.find_by_location(@room["_id"])
        contents_str = ""
        contents.each do |e|
          renderer = @desc_factory.build_room_each_exit(c)
          contents_str << renderer.render
        end
        contents_str
      end

      def build_footer
        renderer = @desc_factory.build_room_footer(@room)
        renderer.render
      end
      
    end
  end
end