module AresMUSH
  module Scenes
    class ScenesCmd
      include CommandHandler
      
      attr_accessor :set, :show_all
      
      def parse_args
        self.show_all = cmd.switch_is?("all")
      end
      
      def handle
        scenes = Scene.all
        if (!show_all)
          scenes = scenes.select { |s| !s.completed }
        end
        template = SceneListTemplate.new(scenes)
        client.emit template.render
      end
    end
  end
end
