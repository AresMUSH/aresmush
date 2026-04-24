module AresMUSH

  module Events
    class EventCreateSceneCmd
      include CommandHandler
      
      attr_accessor :num
      
      def parse_args
        self.num = integer_arg(cmd.args)
      end
      
      def required_args
        [ self.num ]
      end
      
      def handle
        Events.with_an_event(self.num, client, enactor) do |event| 
          scene = Events.create_event_scene(event, enactor)
          Rooms.move_to(client, enactor, scene.room)
        end
      end
    end
  end
end
