module AresMUSH
  module Places
    class PlaceJoinCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
            
      def handle
        place = Places.find_place(enactor_room, self.name)
      
        if (!place)
          place = Place.create(name: self.name, room: enactor_room)
        end
        
        Places.join_place(enactor, place)
      end
    end
  end
end
