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
        
        Places.join_place(enactor, place)
      end
    end
  end
end
