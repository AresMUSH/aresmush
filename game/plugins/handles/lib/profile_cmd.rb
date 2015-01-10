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
        self.name = cmd.args.nil? ? client.char.handle : titleize_input(cmd.args)
      end
      
      def handle
        Handles.get_profile(client, self.name)
      end      
    end

  end
end
