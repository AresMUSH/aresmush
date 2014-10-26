module AresMUSH
  module Handles
    class ProfileSetCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :profile
      
      def initialize
        self.required_args = ['profile']
        self.help_topic = 'profile'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("profile") && cmd.switch_is?("set")
      end
      
      def crack!
        self.profile = cmd.args
      end
      
      def check_slave
        return t('handles.use_command_on_central') if !Global.api_router.is_master?
        return nil
      end
        
      def handle        
        client.char.handle_profile = self.profile
        client.char.save
        client.emit_success t('handles.profile_set')
      end
    end
  end
end
