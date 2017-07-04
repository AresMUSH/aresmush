module AresMUSH
  module Scenes
    class SceneInfoCmd
      include CommandHandler
      
      attr_accessor :scene_num, :value, :setting
      
      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.scene_num = integer_arg(args.arg1)
          self.value = args.arg2
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
          self.value = cmd.args
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
          if (self.setting != "summary")
            self.value = self.value.titlecase
          end

          case self.setting
          when "privacy"
            set_privacy(scene)
            
          when "title"
            scene.update(title: self.value)
            
          when "summary"
            scene.update(summary: self.value)
            
          when "location"
            set_location(scene)
            
          when "type"
            set_type(scene)
          end
          
          if (scene.room)
            scene.room.emit_ooc t('scenes.scene_info_updated_announce', :name => enactor_name, 
            :value => self.value, :setting => self.setting)
          end
          if (enactor_room != scene.room)
            client.emit_success t('scenes.scene_info_updated')
          end
        end
      end
      
      def set_privacy(scene)
        if (self.setting == "privacy")
          if (!Scenes.is_valid_privacy?(self.value))
            client.emit_failure t('scenes.invalid_privacy')
            return
          end
          scene.update(private_scene: self.value == "Private")
        end
      end
        
      def set_type(scene)
        if (!Scenes.scene_types.include?(self.value))
          client.emit_failure t('scenes.invalid_scene_type', 
          :types => Scenes.scene_types.join(", "))
          return
        end
        
        scene.update(scene_type: self.value)
      end
      
      def set_location(scene)
        message = Scenes.set_scene_location(scene, self.value)
        
        if (scene.room)
          scene.room.emit message
        end
        
        if (scene.room != enactor_room)
          client.emit_ooc message
        end
      end
      
    end
  end
end
