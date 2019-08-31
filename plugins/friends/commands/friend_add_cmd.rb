module AresMUSH
  module Friends
    class FriendAddCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        result = ClassTargetFinder.find(self.name, Character, enactor)
        if (!result.found?)
          client.emit_failure result.error
          return
        end
        friend = result.target

        if (enactor.friends.include?(friend))
          client.emit_failure t('friends.already_friend', :name => self.name)
          return
        end
        Friendship.create(:character => enactor, :friend => friend)
        client.emit_success t('friends.friend_added', :name => self.name)
        Achievements.award_achievement(enactor, "friend_added")
      end
    end
  end
end
