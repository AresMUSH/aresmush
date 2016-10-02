module AresMUSH
  module Friends
    class FriendNoteCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :note
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = cmd.args.arg1
        self.note = cmd.args.arg2
      end
      
      def required_args
        {
          args: [ self.name, self.note ],
          help: 'friends'
        }
      end
      
      def handle
        result = Friends.find_friendship(enactor, self.name)
        friendship = result[:friendship]
        if (!friendship)
          client.emit_failure result[:error]
        else
          friendship.note = self.note
          friendship.save!
          client.emit_success t('friends.note_added', :name => self.name)
        end   
      end
    end
  end
end
