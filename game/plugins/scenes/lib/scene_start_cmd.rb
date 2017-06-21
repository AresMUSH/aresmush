module AresMUSH
  module Scenes
    class SceneStartCmd
      include CommandHandler
      
      attr_accessor :title, :privacy
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.title = titlecase_arg(args.arg1)
        self.privacy = titlecase_arg(args.arg2) || "Public"
      end
      
      def required_args
        {
          args: [ self.title, self.privacy ],
          help: 'scenes creating'
        }
      end

      def check_privacy
        return t('scenes.invalid_privacy') if !Scenes.is_valid_privacy(self.privacy)
        return nil
      end
            
      def handle
        scene = Scene.create(owner: enactor, title: self.title, private_scene: self.privacy == "Private")
        room = Room.create(scene: scene, room_type: "RPR", name: "Scene #{scene.id} - #{self.title}")
        ex = Exit.create(name: "O", source: room, dest: Game.master.ooc_room)
        scene.update(room: room)
        Pose.enable_repose(room)
        Rooms.move_to(client, enactor, room)
      end
    end
  end
end
