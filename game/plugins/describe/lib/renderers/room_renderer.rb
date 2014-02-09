module AresMUSH

  module Describe
    class RoomRenderer
      def initialize(room)
        @client_monitor = Global.client_monitor
        @room = room
      end

      def render
        "Room Desc Here"
        #desc = build_header
        #desc << build_main
        #desc << build_chars
        #desc << build_exits
        #desc << build_footer
      end
            
      def build_header
        renderer = @desc_factory.build_room_header(@room)
        renderer.render
      end
      
      def build_main
        renderer = @desc_factory.build_room_header(@room)
        renderer.render
      end
      
      def build_chars
        contents = @client_monitor.clients.select { |c| c.logged_in? && c.room == @room }
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