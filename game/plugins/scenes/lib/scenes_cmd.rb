module AresMUSH
  module Scenes
    class ScenesCmd
      include CommandHandler
      
      attr_accessor :set, :show_all
      
      def parse_args
        self.show_all = cmd.switch_is?("all")
      end
      
      def handle
        if (show_all)
          scenes = Scene.all.select { |s| Scenes.can_access_scene?(enactor, s) }
          paginator = Paginator.paginate(scenes, cmd.page, 25)
          template = SceneSummaryTemplate.new(paginator)
        else
          scenes = Scene.all.select { |s| !s.completed }
          template = SceneListTemplate.new(scenes)
        end
        client.emit template.render
      end
    end
  end
end
