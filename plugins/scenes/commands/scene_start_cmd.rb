module AresMUSH
  module Scenes
    class SceneStartCmd
      include CommandHandler
      
      attr_accessor :location, :privacy, :temp
      
      # scene/start (no args) -->  Here/privacy based on room
      # scene/start (location) -->  Temproom/private
      # scene/start (location)=(privacy) --> Temproom with privacy setting
      
      def parse_args
        if (!cmd.args)
          self.location = enactor_room.name
          self.privacy = enactor_room.room_type == "IC" ? "Open" : "Private"
          self.temp = false
        elsif (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.location = titlecase_arg(args.arg1)
          self.privacy = titlecase_arg(args.arg2)
          self.temp = true
        else
          self.location = titlecase_arg(cmd.args)
          self.privacy = "Private"
          self.temp = true
        end
      end
      
      def required_args
        [ self.location, self.privacy ]
      end

      def check_privacy
        return t('scenes.invalid_privacy') if !Scenes.is_valid_privacy?(self.privacy)
        return nil
      end
      
      def check_approved
        return t('scenes.must_be_approved') if !enactor.is_approved?
        return nil
      end
            
      def handle
        
        private_scene = self.privacy == "Private"
        
        if (!self.temp && enactor_room.room_type == "OOC")
          client.emit_failure t('scenes.no_scene_in_ooc_room')
          return
        end
        
        if self.location == 'Here'
          self.location = enactor_room.name_and_area
        end
                
        if (enactor_room.scene && !self.temp)
          client.emit_failure t('scenes.scene_already_going')
          return
        end
          
        scene = Scenes.start_scene(enactor, self.location, private_scene, Scenes.scene_types.first, self.temp)
        
        if (self.temp)
          Rooms.move_to(client, enactor, scene.room)
        end
      end
    end
  end
end
