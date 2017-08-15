module AresMUSH
  module Places
    class PlaceDeleteCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        place = enactor_room.places.find(name: self.name).first
        
        if (!place)
          client.emit_failure t('places.place_doesnt_exit')
          return
        end
        
        place.delete
        client.emit_success t('places.place_deleted', :name => enactor.name, :place_name => self.name)
      end
    end
  end
end
