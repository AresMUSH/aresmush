module AresMUSH
  module Friends
    class FriendRemoveCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = cmd.args
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        result = Friends.find_friendship(enactor, self.name)
      
        if (result[:friendship].nil?)
          client.emit_failure client.emit_failure result[:error]
          return
        end
      
        result[:friendship].delete
        client.emit_success t('friends.friend_removed', :name => self.name)        
      end
    end
  end
end
