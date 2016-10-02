module AresMUSH
  module Friends
    class FriendAddCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name

      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'friends'
        }
      end
      
      def handle
        result = ClassTargetFinder.find(self.name, Character, enactor)
        if (!result.found?)
          client.emit_failure result.error
          return
        end
        friend = result.target

        if (enactor.friends.include?(friend))
          return t('friends.already_friend', :name => self.name)
        end
        friendship = Friendship.new(:character => enactor, :friend => friend)
        friendship.save!
        client.emit_success t('friends.friend_added', :name => self.name)
      end
    end
  end
end
