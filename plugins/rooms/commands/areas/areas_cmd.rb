module AresMUSH
  module Rooms
    class AreasCmd
      include CommandHandler

      def handle
        areas = Area.all.map { |a| a.name }
        template = BorderedListTemplate.new areas, t('rooms.areas_title')
        client.emit template.render
      end
    end
  end
end
