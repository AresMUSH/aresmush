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
        place = Places.find_place(enactor, self.name)
      
        if (!place)
          client.emit_failure t('places.place_doesnt_exist')
          return
        end
        
        enactor.update(place: place)
        enactor_room.emit_ooc t('places.place_joined', :name => enactor.name, :place_name => place.name)
      end
    end
  end
end
