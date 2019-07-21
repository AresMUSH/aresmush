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
        place = Places.find_place(enactor_room, self.name)
        
        if (!place)
          client.emit_failure t('places.place_doesnt_exist')
          return
        end
        
        place.delete
        client.emit_success t('places.place_deleted', :name => enactor.name, :place_name => place.name)
      end
    end
  end
end
