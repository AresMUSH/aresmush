module AresMUSH
  module Friends
    class AnnounceCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs
      
      attr_accessor :option
      
      def initialize
        self.required_args = ['option']
        self.help_topic = 'announce'
        super
      end
                  
      def want_command?(client, cmd)
        cmd.root_is?("announce")
      end
      
      def crack!
        self.option = cmd.args.nil? ? nil : cmd.args.downcase
      end
      
      def check_option
        return nil if self.option == 'all' || self.option == 'none' || self.option == 'friends'
        t('login.invalid_announce_option')
      end
      
      def handle
        client.char.announce = self.option
        client.char.save!
        if (self.option == "all")
          client.emit_success t('login.announce_all')
        elsif (self.option == "none")
          client.emit_success t('login.announce_none')
        elsif (self.option == "friends")
          client.emit_success t('login.announce_friends')
        end
      end
    end
  end
end
