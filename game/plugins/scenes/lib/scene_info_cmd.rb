module AresMUSH
  module Scenes
    class SceneInfoCmd
      include CommandHandler
      
      attr_accessor :scene_num, :value, :setting
      
      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.scene_num = integer_arg(args.arg1)
          self.value = titlecase_arg(args.arg2)
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
          self.value = titlecase_arg(cmd.args)
        end
        self.setting = cmd.switch.downcase
      end
      
      def required_args
        {
          args: [ self.value ],
          help: 'scenes info'
        }
      end
      
      def handle
         Scenes.with_a_scene(self.scene_num, client) do |scene|
        
          case self.setting
          when "privacy"
            if (self.setting == "privacy")
              if (!Scenes.is_valid_privacy?(self.value))
                client.emit_failure t('scenes.invalid_privacy')
                return
              end
              scene.update(private_scene: self.value == "Private")
            end
            
          when "title"
            scene.update(title: self.value)
            if (scene.temp_room)
              scene.room.update(name: "Scene #{scene.id} - #{title}")
            end
            
          when "summary"
            scene.update(summary: self.value)
            
          when "location"
            scene.update(location: self.value)
            
          when "type"
            if (!Scenes.scene_types.include?(self.value))
              client.emit_failure t('scenes.invalid_scene_type', 
                  :types => Scenes.scene_types.join(", "))
              return
            end
            
            scene.update(scene_type: self.value)
          end
          
          if (scene.room)
            scene.room.emit_ooc t('scenes.scene_info_updated_announce', :name => enactor_name, 
               :value => self.value, :setting => self.setting)
           else
             client.emit_success t('scenes.scene_info_updated')    
          end
        end
      end
    end
  end
end
