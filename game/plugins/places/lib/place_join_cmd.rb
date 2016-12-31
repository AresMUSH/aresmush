module AresMUSH
  module Places
    class PlaceJoinCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'places'
        }
      end
            
      def handle
        place = enactor_room.places.find(name: self.name).first
      
        if (!place)
          client.emit_failure t('places.place_doesnt_exit')
          return
        end
        
        enactor.update(place: place)
        enactor_room.emit_ooc t('places.place_joined', :name => enactor.name, :place_name => self.name)
      end
    end
  end
end
