module AresMUSH
  module Maps
    class MapsCmd
      include CommandHandler

      def handle
        maps = GameMap.all.map { |m| "#{m.name.ljust(20)} #{m.areas.join(',')}" }
        template = BorderedListTemplate.new maps, t('maps.maps_title')
        client.emit template.render
      end
    end
  end
end
