module AresMUSH
  module Scenes
    class SceneListTemplate < ErbTemplateRenderer
             
      attr_accessor :scenes
                     
      def initialize(scenes)
        @scenes = scenes
        super File.dirname(__FILE__) + "/scenes_list.erb"        
      end
      
      def characters(scene)
        scene.participants.map{ |c| c.name }.join(", ")
      end
      
      def organizer(scene)
        "(#{t('scenes.organizer_title', :name => scene.owner.name )})"
      end
      
      def privacy(scene)
        color = scene.private_scene ? "%xr" : "%xg"
        message = scene.private_scene ? t('scenes.private') : t('scenes.public')
        "#{color}#{message}%xn"
      end
    end
  end
end