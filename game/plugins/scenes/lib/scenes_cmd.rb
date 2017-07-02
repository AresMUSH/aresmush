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
          scenes = Scene.all
          list = scenes.map { |s| "#{s.id} - #{s.title || s.location} (#{s.owner.name})"}
          template = BorderedPagedListTemplate.new list, cmd.page, 25, t('scenes.scenes_title')
          
        else
          scenes = Scene.all.select { |s| !s.completed }
          template = SceneListTemplate.new(scenes)
        end
        client.emit template.render
      end
    end
  end
end
