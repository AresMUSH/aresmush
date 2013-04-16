module AresMUSH

  module Describe
    class RoomRenderer
      def initialize(room, container)
        @container = container
        @room = room
      end

      def render
        desc = build_header
        desc << build_content_header
        desc << build_content
        desc << build_exit_header
        desc << build_exits
        desc << build_footer
      end
      
      def build_header
        renderer = RoomHeaderRenderer.new(@room, @container)
        renderer.render
      end
      
      def build_content_header
        renderer = RoomContentRenderer.new(@room, @container)
        renderer.render
      end
      
      def build_exit_header
        renderer = RoomExitRenderer.new(@room, @container)
        renderer.render
      end
      
      def build_content
        contents = Character.find_by_location(@room["_id"])
        contents_str = ""
        contents.each do |c|
          renderer = RoomEachCharRenderer.new(c, @container)
          contents_str << renderer.render
        end
        contents_str
      end

      def build_exits
        contents = Exit.find_by_location(@room["_id"])
        contents_str = ""
        contents.each do |e|
          renderer = RoomEachExitRenderer.new(e, @container)
          contents_str << renderer.render
        end
        contents_str
      end

      def build_footer
        renderer = RoomFooterRenderer.new(@room, @container)
        renderer.render
      end
      
    end
  end
end