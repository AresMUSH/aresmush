module AresMUSH
  module Scenes
    class SceneSummaryTemplate < ErbTemplateRenderer
             
      attr_accessor :paginator
                     
      def initialize(paginator)
        @paginator = paginator
        super File.dirname(__FILE__) + "/scenes_summary.erb"        
      end
      
      def characters(scene)
        names = scene.participant_names
        names.empty? ? "---" : names.join(", ")
      end
      
      def organizer(scene)
        scene.owner_name
      end
      
      def privacy(scene)
        color = scene.private_scene ? "%xr" : "%xg"
        message = scene.private_scene ? t('scenes.private') : t('scenes.open')
        "#{color}#{message}%xn"
      end
      
      def status(scene)
        return '(X)' if scene.in_trash 
        return ' u ' if !scene.shared
        return '   '
      end
    end
  end
end