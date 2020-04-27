module AresMUSH
  module Places
    class PlaceEmitCmd
      include CommandHandler
      
      attr_accessor :name, :emit

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.emit = args.arg2
      end
      
      def required_args
        [ self.name, self.emit ]
      end
      
      def handle
        place = Places.find_place(enactor_room, self.name)
        
        if (!place)
          client.emit_failure t('places.place_doesnt_exist')
          return
        end
        
        
        Scenes.emit(enactor, self.emit, place.name)
      end
      
      def log_command
        # Don't log poses.
      end
    end
  end
end
