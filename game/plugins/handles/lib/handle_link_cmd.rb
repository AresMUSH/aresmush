module AresMUSH
  module Handles
    class HandleLinkCmd
      include Plugin
      include PluginRequiresArgs
      
      attr_accessor :id_or_code

      def initialize
        self.required_args = ['id_or_code']
        self.help_topic = 'handle'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("link")
      end
      
      def crack!
        self.id_or_code = trim_input(cmd.args)
      end
      
      def handle
        Api.link_character(client, id_or_code)
      end      
    end

  end
end
