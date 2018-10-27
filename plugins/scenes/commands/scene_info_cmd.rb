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
        [ self.value ]
      end
      
      def handle
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!Scenes.can_access_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end

          if (self.setting != "summary")
            self.value = self.value.titlecase
          end

          case self.setting
          when "privacy"
            success = set_privacy(scene)
            
          when "icdate"
            success = set_icdate(scene)
          
          when "plot"
            success = set_plot(scene)
            
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
          end
          
          if (success)
            if (scene.room)
              scene.room.emit_ooc t('scenes.scene_info_updated_announce', :name => enactor_name, 
                :value => self.value, :setting => self.setting)
            end
            if (enactor_room != scene.room)
              client.emit_success t('scenes.scene_info_updated')
            end
          end
        end
      end
      
      def set_privacy(scene)
        if (!Scenes.is_valid_privacy?(self.value))
          client.emit_failure t('scenes.invalid_privacy')
          return false
        end
        
        is_private = self.value == "Private"
        
        if (is_private && scene.room.room_type == "IC")
          client.emit_failure t('scenes.private_scene_in_public_room')
        end
        
        scene.update(private_scene: is_private)
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

      def set_plot(scene)
        plot_num = self.value.to_i
        plot = Plot[plot_num]
        if (!plot)
          plot = Plot.all.first { |p| p.title.upcase == self.value.upcase }
        end
        
        if (!plot)
          client.emit_failure t('scenes.invalid_plot')
          return false
        end
        
        scene.update(plot: plot)
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
        message = Scenes.set_scene_location(scene, self.value)
        
        if (scene.room)
          scene.room.emit message
          if (!scene.temp_room)
            client.emit_failure t('scenes.grid_location_change_warning')
          end
        end
        
        if (scene.room != enactor_room)
          client.emit_ooc message
        end
        return true
      end
      
    end
  end
end
