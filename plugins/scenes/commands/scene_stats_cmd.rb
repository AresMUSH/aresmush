module AresMUSH
  module Scenes
    class SceneStatsCmd
      include CommandHandler
      
      def handle
        template = SceneStatsTemplate.new(Scenes.scene_stats)
        client.emit template.render
      end
    end
  end
end
