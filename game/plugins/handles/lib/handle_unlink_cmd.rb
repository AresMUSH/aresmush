module AresMUSH
  module Handles
    class HandleUnlinkCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :char_id

      def initialize
        self.required_args = ['char_id']
        self.help_topic = 'handle'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("unlink")
      end
      
      def crack!
        self.char_id = trim_input(cmd.args)
      end
      
      def handle
        Handles.unlink_character(client, char_id)
      end      
    end

  end
end
