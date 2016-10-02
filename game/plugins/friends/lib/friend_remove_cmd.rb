module AresMUSH
  module Friends
    class FriendRemoveCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name

      def crack!
        self.name = cmd.args
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'friends'
        }
      end
      
      def handle
        result = Friends.find_friendship(char, friend_name)
      
        if (result[:friendship].nil?)
          return client.emit_failure result[:error]
        end
      
        result[:friendship].destroy
        client.emit_success t('friends.friend_removed', :name => self.name)        
      end
    end
  end
end
