module AresMUSH
  module Friends
    class FriendNoteCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :note
      
      def initialize
        self.required_args = ['name', 'note']
        self.help_topic = 'friends'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("friend") && cmd.switch_is?("note")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = cmd.args.arg1
        self.note = cmd.args.arg2
      end
      
      def handle
        if (self.name.start_with?("@"))
          client.emit_ooc t('friends.note_on_arescentral_only')
        else
          result = Friends.find_friendship(client.char, self.name)
          friendship = result[:friendship]
          if (friendship.nil?)
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
end
