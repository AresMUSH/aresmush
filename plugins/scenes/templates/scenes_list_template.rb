module AresMUSH
  module Scenes
    class SceneListTemplate < ErbTemplateRenderer
             
      attr_accessor :scenes, :enactor
                     
      def initialize(scenes, enactor)
        @scenes = scenes
        @enactor = enactor
        super File.dirname(__FILE__) + "/scenes_list.erb"        
      end
      
      def characters(scene)
        scene.participant_names.join(", ")
      end
      
      def organizer(scene)
        "(#{t('scenes.organizer_title', :name => scene.owner_name )})"
      end
      
      def last_activity(scene)
        OOCTime.local_long_timestr(self.enactor, scene.last_activity)
      end
      
      def privacy(scene)
        color = scene.private_scene ? "%xr" : "%xg"
        message = scene.private_scene ? t('scenes.private') : t('scenes.open')
        "#{color}#{message}%xn"
      end
    end
  end
end