module AresMUSH
  module Places
    class PlacesCmd
      include CommandHandler
      include CommandRequiresLogin
            
      def handle
        template = PlacesTemplate.new(enactor_room)
        client.emit template.render
      end
    end
  end
end
