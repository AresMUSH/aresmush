module AresMUSH
  module Places
    class PlaceRenameCmd
      include CommandHandler
      
      attr_accessor :old_name, :new_name

      def crack!
        cmd.crack_args!(ArgParser.arg1_equals_arg2)
        self.old_name = titleize_input(cmd.args.arg1)
        self.new_name = titleize_input(cmd.args.arg2)
      end
      
      def required_args
        {
          args: [ self.old_name, self.new_name ],
          help: 'places'
        }
      end
            
      def handle
        place = enactor_room.places.find(name: self.old_name).first
      
        if (!place)
          client.emit_failure t('places.place_doesnt_exit')
          return
        end
        
        place.update(name: new_name)
        enactor_room.emit_ooc t('places.renamed_place', :name => enactor.name, 
          :old_name => self.old_name, :new_name => self.new_name)
      end
    end
  end
end
