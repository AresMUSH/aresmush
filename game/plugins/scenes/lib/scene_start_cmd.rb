module AresMUSH
  module Scenes
    class SceneStartCmd
      include CommandHandler
      
      attr_accessor :location, :privacy
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.location = titlecase_arg(args.arg1)
        self.privacy = titlecase_arg(args.arg2) || "Public"
      end
      
      def required_args
        {
          args: [ self.location, self.privacy ],
          help: 'scenes'
        }
      end

      def check_privacy
        return t('scenes.invalid_privacy') if !Scenes.is_valid_privacy(self.privacy)
        return nil
      end
            
      def handle
        result = ClassTargetFinder.find(self.location, Room, enactor)
        if (result.found?)
          self.location = result.target.name  
          description = result.target.description   
        end
        
        scene = Scene.create(owner: enactor, location: self.location, private_scene: self.privacy == "Private")
        room = Room.create(scene: scene, room_type: "RPR", name: "Scene #{scene.id} - #{self.location}")
        ex = Exit.create(name: "O", source: room, dest: Game.master.ooc_room)
        scene.update(room: room)
        room.create_desc("current", description)
        Pose.enable_repose(room)
        Rooms.move_to(client, enactor, room)
      end
    end
  end
end
