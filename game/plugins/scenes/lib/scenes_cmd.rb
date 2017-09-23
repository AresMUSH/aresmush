module AresMUSH
  module Scenes
    class ScenesCmd
      include CommandHandler
      
      attr_accessor :mode
      
      def parse_args
        case cmd.switch
        when "all"
          self.mode = :all
        when "unshared"
          self.mode = :unshared
        else
          self.mode = :active
        end
      end
      
      def handle
        if (self.mode == :active)
          scenes = Scene.all.select { |s| !s.completed }.reverse
          template = SceneListTemplate.new(scenes)
        else
          
          scenes = Scene.all.select { |s| Scenes.can_access_scene?(enactor, s) }.reverse
          
          if (self.mode == :unshared)
            scenes = scenes.select { |s| !s.shared }
          end
          
          paginator = Paginator.paginate(scenes, cmd.page, 25)
          template = SceneSummaryTemplate.new(paginator)
          
        end
        client.emit template.render
      end
    end
  end
end
