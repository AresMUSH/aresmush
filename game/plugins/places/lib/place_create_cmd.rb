module AresMUSH
  module Places
    class PlaceCreateCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
            
      def handle
        place = Places.find_place(enactor, self.name)
      
        if (place)
          client.emit_failure t('places.place_already_exists')
          return
        end
          
        place = Place.create(name: self.name, room: enactor_room)
        enactor.update(place: place)
        enactor_room.emit_ooc t('places.place_created', :name => enactor.name, :place_name => self.name)
      end
    end
  end
end
