module AresMUSH

  module Describe
    class RoomRenderer
      def initialize(room, desc_factory)
        @desc_factory = desc_factory
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
        contents = Character.find_by_location(@room["_id"])
        contents_str = ""
        contents.each do |c|
          renderer = @desc_factory.build_room_each_char(c)
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