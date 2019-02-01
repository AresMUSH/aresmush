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
        scene.participants.select { |p| !p.who_hidden }
           .sort_by { |p| p.name }
           .map { |p| p.room == scene.room ? p.name : "%xh%xx#{p.name}%xn"}
           .join(", ")
        
      end
      
      def title(scene)
        return "##{scene.id} <#{privacy(scene)}>" if scene.private_scene
        "##{scene.id} <#{privacy(scene)}> - #{scene.title || scene.location}"
      end
      
      def organizer(scene)
        "#{t('scenes.organizer_title', :name => scene.owner_name )}"
      end
      
      def location(scene)
        scene.private_scene ? t('scenes.private') : "#{scene.location} (#{location_type(scene)})"
      end
      
      def last_activity(scene)
        return "-" if !scene.last_activity
        TimeFormatter.format(Time.now - scene.last_activity)
      end
      
      def location_type(scene)
        scene.temp_room ? t('scenes.temproom_scene') : t('scenes.grid_scene')
      end
      
      def privacy(scene)
        color = scene.private_scene ? "%xr" : "%xg"
        message = scene.private_scene ? t('scenes.private') : t('scenes.open')
        "#{color}#{message}%xn"
      end
    end
  end
end