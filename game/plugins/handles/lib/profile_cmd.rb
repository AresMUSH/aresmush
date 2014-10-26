module AresMUSH
  module Handles
    class ProfileCmd
      include Plugin
      include PluginRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'profile'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("profile") && cmd.switch.nil?
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_handle
        return t('handles.must_have_handle_to_view_profile') if client.char.handle.blank? && !Global.api_router.is_master?
        return nil
      end
      
      def handle
        Handles.get_profile(client, self.name)
      end      
    end

  end
end
