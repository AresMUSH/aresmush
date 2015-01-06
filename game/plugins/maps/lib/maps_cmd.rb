module AresMUSH
  module Maps
    class MapsCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginWithoutArgs
      include PluginRequiresLogin

      def want_command?(client, cmd)
        cmd.root_is?("maps")
      end
            
      def handle
        client.emit BorderedDisplay.list Maps.available_maps, t('maps.maps_title')
      end
    end
  end
end
