module AresMUSH
  module Friends
    class FriendRemoveCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'friends'
        super
      end
      
      def crack!
        self.name = cmd.args
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
