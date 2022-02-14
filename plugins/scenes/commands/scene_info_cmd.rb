module AresMUSH
  module Scenes
    class SceneInfoCmd
      include CommandHandler
      
      attr_accessor :scene_num, :value, :setting
      
      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
          self.scene_num = integer_arg(args.arg1)
          self.value = args.arg2
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
          self.value = cmd.args
        end
        self.setting = cmd.switch.downcase
      end      
      
      def handle
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!Scenes.can_edit_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end

          requires_value = ['privacy', 'icdate', 'type', 'pacing']
          if (requires_value.include?(self.setting) && !self.value) 
            client.emit_failure t('dispatcher.invalid_syntax', :cmd => "scene/#{setting}")
            return
          end

          if (self.setting != "summary" && self.setting != "limit")
            self.value = self.value ? self.value.titlecase : nil
          end
          
          case self.setting
          when "privacy"
            success = set_privacy(scene)
            
          when "icdate"
            success = set_icdate(scene)
            
          when "title"
            scene.update(title: self.value)
            success = true
            
          when "summary"
            scene.update(summary: self.value)
            success = true
            
          when "location"
            success = set_location(scene)
            
          when "type"
            success = set_type(scene)
            
          when "pacing"
            success = set_pacing(scene)
            
          when "warning"
            scene.update(content_warning: self.value)
            success = true
            
          when "limit", "note", "notes"
            scene.update(limit: self.value.downcase == "none" ? nil : self.value)
            success = true
          end
          
          if (success)
            client.emit_success t('scenes.scene_info_updated')
          end
        end
      end
      
      def set_privacy(scene)
        if (!Scenes.is_valid_privacy?(self.value))
          client.emit_failure t('scenes.invalid_privacy')
          return false
        end
        
        is_private = self.value == "Private"
        
        if (is_private && scene.room && scene.room.room_type == "IC")
          client.emit_failure t('scenes.private_scene_in_public_room')
        end
        
        scene.update(private_scene: is_private)
        if (is_private)
          scene.watchers.replace []
        end
        return true
      end
        
      def set_type(scene)
        if (!Scenes.scene_types.include?(self.value))
          client.emit_failure t('scenes.invalid_scene_type', 
          :types => Scenes.scene_types.join(", "))
          return false
        end
        
        scene.update(scene_type: self.value)
        return true
      end
      
      def set_pacing(scene)        
        pacing = Scenes.scene_pacing.select { |p| p.downcase.start_with?(self.value.downcase)}.first
        if (!pacing)
          client.emit_failure t('scenes.invalid_scene_pacing', 
          :types => Scenes.scene_pacing.join(", "))
          return false
        end
        
        scene.update(scene_pacing: pacing)
        return true
      end

      def set_icdate(scene)
        if (self.value !~ /\d\d\d\d-\d\d-\d\d/)
          client.emit_failure t('scenes.invalid_icdate_format')
          return false
        end
        scene.update(icdate: self.value)
        return true
      end
      
      def set_location(scene)
        if (scene.completed)
          client.emit_failure t('scenes.scene_already_completed')
          return false
        end

        Scenes.set_scene_location(scene, self.value, enactor)
        
        if (scene.room && !scene.temp_room)
          client.emit_failure t('scenes.grid_location_change_warning')
        end
        
        return true
      end
      
    end
  end
end
