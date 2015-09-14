module AresMUSH
  module Handles
    class ProfileDeleteCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :field
     
      def initialize
        self.required_args = ['field']
        self.help_topic = 'profile'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("profile") && cmd.switch_is?("delete")
      end

      def crack!
        self.field = titleize_input(cmd.args)
      end
      
      def handle
        client.char.profile.delete self.field
        client.char.save!
        client.emit_success t('handles.custom_profile_cleared', :field => self.field)
      end
    end
  end
end