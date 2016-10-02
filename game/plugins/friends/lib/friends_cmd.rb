module AresMUSH
  module Friends
    class FriendsCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      
      def handle
        template = FriendsTemplate.new(enactor)
        client.emit template.render        
      end
    end
  end
end
