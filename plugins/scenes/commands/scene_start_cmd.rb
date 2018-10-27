module AresMUSH
  module Scenes
    class SceneStartCmd
      include CommandHandler
      
      attr_accessor :location, :privacy, :temp
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.location = titlecase_arg(args.arg1)
          self.privacy = titlecase_arg(args.arg2)
          self.temp = true
        else
          self.location = enactor_room.name
          self.privacy = enactor_room.room_type == "IC" ? "Open" : "Private"
          self.temp = false
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
        
        if (!self.temp && enactor_room.room_type == "OOC")
          client.emit_failure t('scenes.no_scene_in_ooc_room')
          return
        end
        
        if (enactor_room.scene)
          client.emit_failure t('scenes.scene_already_going')
          return
        end
        
        scene = Scene.create(owner: enactor, 
            location: self.location, 
            private_scene: self.privacy == "Private",
            scene_type: Scenes.scene_types.first,
            temp_room: self.temp,
            icdate: ICTime.ictime.strftime("%Y-%m-%d"))

        Global.logger.info "Scene #{scene.id} started by #{enactor.name} in #{self.temp ? 'temp room' : enactor_room.name}."
            
        if (self.temp)
          room = Scenes.create_scene_temproom(scene)
          Rooms.move_to(client, enactor, room)
        else
          room = enactor_room
          room.update(scene: scene)
          scene.update(room: room)
          room.emit_ooc t('scenes.announce_scene_start', :privacy => self.privacy, :name => enactor_name)
        end
      end
    end
  end
end
