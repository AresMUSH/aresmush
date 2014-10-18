module AresMUSH
  module Friends
    class FriendRemoveCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'friends'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("friend") && cmd.switch_is?("remove")
      end
      
      def crack!
        self.name = cmd.args
      end
      
      def handle
        if (self.name.start_with?("@"))
          if (!client.char.handle_friends.include?(self.name))
            client.emit_failure t('friends.not_friend', :name => self.name)
            return
          end
          
          client.char.handle_friends.delete self.name
          client.char.save!
          client.emit_success t('friends.friend_removed', :name => self.name)
          return
        end
        
        ClassTargetFinder.with_a_character(self.name, client) do |friend|
          friendship = Friendship.where(:character => client.char, :friend => friend)
          if (friendship.nil?)
            client.emit_failure t('friends.not_friend', :name => self.name)
            return
          end
          
          friendship.destroy

          client.emit_success t('friends.friend_removed', :name => self.name)
        end
      end
    end
  end
end
