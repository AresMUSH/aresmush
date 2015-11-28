module AresMUSH
  module Maps
    class MapsCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandWithoutArgs
      include CommandRequiresLogin

      def want_command?(client, cmd)
        cmd.root_is?("map") && !cmd.args
      end
            
      def handle
        client.emit BorderedDisplay.list Maps.available_maps, t('maps.maps_title')
      end
    end
  end
end
