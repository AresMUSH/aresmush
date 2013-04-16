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
    end
  end
end