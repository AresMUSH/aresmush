module AresMUSH
  module Friends
    class FriendsCmd
      include CommandHandler
      
      def handle
        template = FriendsTemplate.new(enactor)
        client.emit template.render        
      end
    end
  end
end
