module AresMUSH
  module Handles
    class HandleLinkCodeCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :char_id

      def initialize
        self.required_args = ['char_id']
        self.help_topic = 'handle'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("linkcode")
      end
      
      def check_not_guest
        return t('dispatcher.not_allowed') if client.char.is_guest?
        return nil
      end
      
      def crack!
        self.char_id = trim_input(cmd.args)
      end
      
      def handle
        Handles.get_link_code(client, char_id)
      end      
    end

  end
end
