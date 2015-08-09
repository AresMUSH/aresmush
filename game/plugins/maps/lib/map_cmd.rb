module AresMUSH
  module Maps
    class MapCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresLogin
      
      attr_accessor :area
      
      def want_command?(client, cmd)
        cmd.root_is?("map") && cmd.args
      end
            
      def crack!
        self.area = cmd.args.nil? ? client.room.area : titleize_input(cmd.args)
      end
      
      def handle
        map = Maps.map_for_area(self.area)
        
        if (!map)
          client.emit_failure t('maps.no_such_map')
          return
        end
        
        client.emit BorderedDisplay.text map, t('maps.map_title', :area => self.area)
      end
    end
  end
end
