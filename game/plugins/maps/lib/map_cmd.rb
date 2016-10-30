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
        map = Maps.get_map(self.area)
      
        if (!map)
          client.emit_failure t('maps.no_such_map')
        else
          map_text = File.read(File.join(Maps.maps_dir, map), :encoding => "UTF-8")
          client.emit BorderedDisplay.text map_text, t('maps.map_title', :area => self.area)
        end
      end
    end
  end
end
