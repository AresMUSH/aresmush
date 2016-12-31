module AresMUSH
  module Places
    class PlaceCreateCmd
      include CommandHandler
      
      attr_accessor :name

      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'places'
        }
      end
      
      def check_place_exists
        return t('places.place_already_exists') if enactor_room.places.find(name: self.name).first
        return nil
      end
      
      def handle
        place = Place.create(name: self.name, room: enactor_room)
        enactor.update(place: place)
        client.emit_success t('places.place_created', :name => enactor.name, :place_name => self.name)
      end
    end
  end
end
