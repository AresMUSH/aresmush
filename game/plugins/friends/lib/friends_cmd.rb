module AresMUSH
  module Friends
    class FriendsCmd
      include CommandHandler
      
      def help
        "`friends` - Shows your friends list."
      end
      
      def handle
        template = FriendsTemplate.new(enactor)
        client.emit template.render        
      end
    end
  end
end
