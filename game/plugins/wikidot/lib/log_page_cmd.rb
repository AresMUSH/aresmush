module AresMUSH
  module Wikidot
    class LogPageCmd
      include CommandHandler
      
      attr_accessor :scene

      def parse_args
        self.scene = integer_arg(cmd.args)
      end
      
      def required_args
        [ self.scene ]
      end
      
      def handle
        scene = Scene[self.scene]
        if (!scene)
          client.emit_failure t('scenes.scene_not_found')
          return
        end
        
        if (!Scenes.can_access_scene?(enactor, scene))
          client.emit_failure t('scenes.access_not_allowed')
          return
        end

        if (!scene.completed)
          client.emit_failure t('wikidot.only_completed_logs')
          return
        end
        
        if (!scene.all_info_set?)
          client.emit_failure t('scenes.scene_info_missing', :title => scene.title || "??", 
             :summary => scene.summary || "??", 
             :type => scene.scene_type || "??", 
             :location => scene.location || "??")
          return
        end
        
        if (!scene.shared)
          Scenes.share_scene(scene)
        end
        
        client.emit_ooc t('wikidot.creating_log_page')
        Wikidot.create_log(scene, client, true)
      end
    end
  end
end
