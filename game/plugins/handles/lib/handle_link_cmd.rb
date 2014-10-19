module AresMUSH
  module Handles
    class HandleLinkCmd
      include Plugin
      include PluginRequiresArgs
      
      attr_accessor :handle_name, :code

      def initialize
        self.required_args = ['handle_name', 'code']
        self.help_topic = 'handle'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("link")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.handle_name = cmd.args.arg1
        self.code = cmd.args.arg2
      end
      
      def handle
        Api.link_character(client, handle_name, code)
      end      
    end

  end
end
