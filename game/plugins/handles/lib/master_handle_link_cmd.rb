module AresMUSH
  module Handles
    class MasterHandleLinkCmd
      include Plugin
      include PluginRequiresArgs
      
      attr_accessor :char_id

      def initialize
        self.required_args = ['char_id']
        self.help_topic = 'handle'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("link") && cmd.args !~ /=/
      end
      
      def crack!
        self.char_id = trim_input(cmd.args)
      end
      
      def handle
        Api.get_link_code(client, char_id)
      end      
    end

  end
end
