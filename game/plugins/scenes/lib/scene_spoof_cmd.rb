module AresMUSH
  module Scenes
    class SceneSpoofCmd
      include CommandHandler
      
      attr_accessor :scene_num, :old_name, :new_name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.scene_num = integer_arg(args.arg1)
        self.old_name = titlecase_arg(args.arg2)
        self.new_name = titlecase_arg(args.arg3)
      end
      
      def required_args
        [ self.old_name, self.new_name ]
      end
      
      def handle        
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!Scenes.can_access_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end

          old_char = Character.find_one_by_name(self.old_name)
          new_char = Character.find_one_by_name(self.new_name)

          if (!old_char || !new_char)
            client.emit_failure t("db.object_not_found")
            return
          end
          
          scene.scene_poses.each do |p|
            if (p.character == old_char)
              p.update(character: new_char)
            end
          end
          
          client.emit_success t('scenes.scene_char_replaced', :id => scene.id, :old_name => self.old_name, :new_name => self.new_name)
        end
      end
    end
  end
end
