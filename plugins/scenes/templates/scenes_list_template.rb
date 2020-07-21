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
           .map { |p| Status.is_active?(p) ? p.name : "%xh%xx#{p.name}%xn"}
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
        self.can_read?(scene) ? "#{scene.location} (#{location_type(scene)})" : t('scenes.private')
      end

      def last_activity(scene)
        return "-" if !self.can_read?(scene)
        return "-" if !scene.last_activity
        TimeFormatter.format(Time.now - scene.last_activity)
      end

      def location_type(scene)
        scene.temp_room ? t('scenes.temproom_scene') : t('scenes.grid_scene')
      end

      def summary(scene)
        return nil if !scene.summary
        return scene.summary if scene.summary.length < 150
        "#{scene.summary.truncate(150)}..."
      end

      def privacy(scene)
        if (scene.private_scene)
          color = "%xr"
          message = t('scenes.private')
        elsif scene.watchable_scene
          message = "Watchable"
          color = "%xc"
        elsif (scene.limited_participation?)
          color = "%xy"
          message = t('scenes.limited')
        else
          color = "%xg"
          message = t('scenes.open')
        end
        "#{color}#{message}%xn"
      end

      def can_read?(scene)
        Scenes.can_read_scene?(@enactor, scene)
      end
    end
  end
end
