module AresMUSH
  module Scenes
    class LogCmd
      include CommandHandler
      
      attr_accessor :all
      attr_accessor :scene_num
      
      def parse_args
        if (cmd.args)
          self.scene_num = integer_arg(cmd.args)
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
        end
        self.all = !cmd.switch_is?("repose")
      end
      
      def handle        
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!scene.logging_enabled)
            client.emit_failure t('scenes.logging_not_enabled')
            return
          end
          poses = scene.scene_poses.to_a
          footer = nil
          if (!self.all)
            poses = poses[-8, 8] || poses
            footer = "%ld%R" + t('scenes.log_list_short_footer')
          end
        
          template = BorderedListTemplate.new poses.map { |p| "#{p.pose}%R"}, t('scenes.log_list'), footer
          client.emit template.render
        end
      end
    end
  end
end
