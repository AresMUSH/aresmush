module AresMUSH
  module Friends
    class FriendsCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("friends") && cmd.switch.nil?
      end
      
      def handle
        friends = client.char.friends.map { |f| f.name }
        client.emit BorderedDisplay.list(friends.sort, t('friends.friends_title'))
      end
    end
  end
end
