module AresMUSH
  module Scenes
    class ScenesCmd
      include CommandHandler
      
      attr_accessor :set
      
      def handle
        scenes = Scene.all
        template = SceneListTemplate.new(scenes)
        client.emit template.render
      end
    end
  end
end
