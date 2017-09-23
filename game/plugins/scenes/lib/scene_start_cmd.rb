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
          self.privacy = enactor_room.room_type == "IC" ? "Public" : "Private"
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
            
        if (self.temp)
          room = Room.create(scene: scene, room_type: "RPR", name: "Scene #{scene.id} - #{self.location}")
          ex = Exit.create(name: "O", source: room, dest: Game.master.ooc_room)
          scene.update(room: room)
          Scenes.set_scene_location(scene, self.location)
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
