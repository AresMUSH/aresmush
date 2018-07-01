module AresMUSH
  module Rooms
    class AreasCmd
      include CommandHandler

      def handle
        template = AreasTemplate.new
        client.emit template.render
      end
    end
  end
end
