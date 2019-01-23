module AresMUSH
  module Scenes
    class SceneCharCmd
      include CommandHandler
      
      attr_accessor :scene_num, :char_name, :add_char
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.scene_num = integer_arg(args.arg1)
        self.char_name = titlecase_arg(args.arg2)
        self.add_char = cmd.switch_is?("addchar")
      end
      
      def required_args
        [ self.char_name, self.scene_num ]
      end
      
      def handle        
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!Scenes.can_edit_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end

          char = Character.find_one_by_name(self.char_name)

          if (!char)
            client.emit_failure t("db.object_not_found")
            return
          end
          
          if (self.add_char)
            if (!scene.participants.include?(char))
              scene.participants.add char
            end
            client.emit_success t('scenes.scene_char_added', :name => char.name)            
          else
            if (scene.participants.include?(char))
              scene.participants.delete char
            end
            client.emit_success t('scenes.scene_char_removed', :name => char.name)            
          end
        end
      end
    end
  end
end
