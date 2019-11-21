module AresMUSH
  module Rooms
    class ExitsCmd
      include CommandHandler
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        list = enactor_room.exits.map { |e| "#{e.dbref.ljust(6)} #{e.name.ljust(10)} #{e.destination_name}" }
        template = BorderedListTemplate.new list
        client.emit template.render
      end
    end
  end
end
