module AresMUSH
  module Scenes
    class SceneSummaryTemplate < ErbTemplateRenderer
             
      # Mode is :all, :profile, :unshared
      attr_accessor :paginator, :mode
                     
      def initialize(paginator, mode)
        @paginator = paginator
        @mode = mode
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
      
      def show_legend
        self.mode != :profile
      end
      
      def title
        "scenes.scenes_title_#{self.mode}"
      end
    end
  end
end