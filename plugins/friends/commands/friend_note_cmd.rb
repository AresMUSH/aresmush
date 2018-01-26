module AresMUSH
  module Friends
    class FriendNoteCmd
      include CommandHandler
      
      attr_accessor :name, :note
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = args.arg1
        self.note = args.arg2
      end
      
      def required_args
        [ self.name, self.note ]
      end
      
      def handle
        result = Friends.find_friendship(enactor, self.name)
        friendship = result[:friendship]
        if (!friendship)
          client.emit_failure result[:error]
          return
        end
        friendship.update(note: self.note)
        client.emit_success t('friends.note_added', :name => self.name)   
      end
    end
  end
end
