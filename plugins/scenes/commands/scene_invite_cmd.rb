module AresMUSH
  module Scenes
    class SceneInviteCmd
      include CommandHandler
      
      attr_accessor :scene_num, :char_names, :invited
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.char_names = list_arg(args.arg1)
        if (args.arg2)
          self.scene_num = integer_arg(args.arg2)
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
        end
        self.invited = cmd.switch_is?("invite")
      end
      
      def required_args
        [ self.char_names, self.scene_num ]
      end
      
      def handle        
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!Scenes.can_read_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end

          self.char_names.each do |name|
            char = Character.find_one_by_name(name)

            if (!char)
              client.emit_failure t("db.object_not_found")
              return
            end
          
            if (self.invited)
              Scenes.invite_to_scene(scene, char, enactor)
              client.emit_success t('scenes.scene_char_invited', :name => char.name)
            else
              Scenes.uninvite_from_scene(scene, char, enactor)
              client.emit_success t('scenes.scene_char_uninvited', :name => char.name)            
            end
          end
        end
      end
    end
  end
end
