module AresMUSH
  module Scenes
    class SceneSummaryTemplate < ErbTemplateRenderer
             
      attr_accessor :paginator
                     
      def initialize(paginator)
        @paginator = paginator
        super File.dirname(__FILE__) + "/scenes_summary.erb"        
      end
      
      def characters(scene)
        scene.participants.map{ |c| c.name }.join(", ")
      end
      
      def organizer(scene)
        scene.owner_name
      end
      
      def privacy(scene)
        color = scene.private_scene ? "%xr" : "%xg"
        message = scene.private_scene ? t('scenes.private') : t('scenes.public')
        "#{color}#{message}%xn"
      end
    end
  end
end