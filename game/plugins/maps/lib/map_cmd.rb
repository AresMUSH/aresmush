module AresMUSH
  module Maps
    class MapCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      
      attr_accessor :area
      
      def crack!
        self.area = !cmd.args ? enactor_room.area : titleize_input(cmd.args)
      end
      
      def handle
        map_file = Maps.get_map_file(self.area)
      
        if (!map)
          client.emit_failure t('maps.no_such_map')
        else
          map_text = Maps.load_map(map_file)
          client.emit BorderedDisplay.text map_text, t('maps.map_title', :area => self.area)
        end
      end
    end
  end
end
