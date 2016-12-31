module AresMUSH
  module Maps
    class MapsCmd
      include CommandHandler

      def handle
        maps = GameMap.all.map { |m| "#{m.name.ljust(20)} #{m.areas.join(',')}" }
        client.emit BorderedDisplay.list maps, t('maps.maps_title')
      end
    end
  end
end
