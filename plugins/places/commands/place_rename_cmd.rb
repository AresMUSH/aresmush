module AresMUSH
  module Places
    class PlaceRenameCmd
      include CommandHandler
      
      attr_accessor :old_name, :new_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.old_name = titlecase_arg(args.arg1)
        self.new_name = titlecase_arg(args.arg2)
      end
      
      def required_args
        [ self.old_name, self.new_name ]
      end
            
      def handle
        place = Places.find_place(enactor_room, self.old_name)
      
        if (!place)
          client.emit_failure t('places.place_doesnt_exist')
          return
        end
        
        if (Places.find_place(enactor_room, self.new_name))
          client.emit_failure t('places.place_already_exists')
          return
        end
        
        self.old_name = place.name
        place.update(name: new_name)
        enactor_room.emit_ooc t('places.renamed_place', :name => enactor.name, 
          :old_name => self.old_name, :new_name => self.new_name)
      end
    end
  end
end
