module AresMUSH
  module Describe
    class DescFactory
      def self.build(model, container)
        if (model["type"] == "Room")
          RoomRenderer.new(model, container)
        elsif (model["type"] == "Character")
          CharRenderer.new(model, container)
        elsif (model["type"] == "Exit")
          ExitRenderer.new(model, container)
        else
          raise "Invalid model type: #{model["type"]}"
        end
      end
      
      def self.build_room_content_renderer(model, container)
        RoomContentRenderer.new(model, container)
      end

      def self.build_room_exit_renderer(model, container)
        RoomExitRenderer.new(model, container)
      end

      def self.build_room_header_renderer(model, container)
        RoomHeaderRenderer.new(model, container)
      end

      def self.build_room_footer_renderer(model, container)
        RoomFooterRenderer.new(model, container)
      end
    end
  end
end