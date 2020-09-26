module AresMUSH
  module Scenes
    class SceneCharCmd
      include CommandHandler
      
      attr_accessor :scene_num, :char_names, :add_char
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.scene_num = integer_arg(args.arg1)
        self.char_names = list_arg(args.arg2)
        self.add_char = cmd.switch_is?("addchar")
      end
      
      def required_args
        [ self.char_names, self.scene_num ]
      end
      
      def handle        
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!Scenes.can_edit_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end

          self.char_names.each do |name|
            char = Character.find_one_by_name(name)

            if (!char)
              client.emit_failure t("db.object_not_found")
              return
            end
          
            if (self.add_char)
              Scenes.add_participant(scene, char, enactor)
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
end
