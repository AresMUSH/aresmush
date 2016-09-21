module AresMUSH
  module Maps
    class MapsCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandWithoutArgs
      include CommandRequiresLogin

      def handle
        client.emit BorderedDisplay.list Maps.available_maps, t('maps.maps_title')
      end
    end
  end
end
