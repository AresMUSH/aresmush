module AresMUSH
  module Friends
    class FriendAddCmd
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
        cmd.root_is?("friend") && cmd.switch_is?("add")
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        error = Friends.add_friend(client.char, self.name)
        if (error)
          client.emit_failure error
        else
          client.emit_success t('friends.friend_added', :name => self.name)
        end
      end
    end
  end
end
