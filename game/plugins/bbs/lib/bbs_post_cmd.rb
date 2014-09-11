module AresMUSH
  module Bbs
    class BbsPostCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :board_name, :subject, :message

      def initialize
        self.required_args = ['board_name', 'subject', 'message']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch_is?("post")
      end
      
      def crack!
        if (cmd.args =~ /^[^=\/]+=[^\/=]+\/.+/)
          cmd.crack_args!(/(?<name>[^\=]+)=(?<subject>[^\/]+)\/(?<message>.+)/)
        else
          cmd.crack_args!(/(?<name>[^\/]+)\/(?<subject>[^\=]+)\=(?<message>.+)/)
        end
        self.board_name = trim_input(cmd.args.name)
        self.subject = trim_input(cmd.args.subject)
        self.message = cmd.args.message
      end
      
      def handle        
        Bbs.post(self.board_name, self.subject, self.message, client.char, client)
      end
    end
  end
end