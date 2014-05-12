module AresMUSH
  module Bbs
    class BbsPostCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :subject, :message

      def initialize
        self.required_args = ['name', 'subject', 'message']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch_is?("post")
      end
      
      def crack!
        if (cmd.args =~ /.+=.+\/.+/)
          cmd.crack!(/(?<name>[^\=]+)=(?<subject>[^\/]+)\/(?<message>.+)/)
        else
          cmd.crack!(/(?<name>[^\/]+)\/(?<subject>[^\=]+)\=(?<message>.+)/)
        end
        self.subject = trim_input(cmd.args.subject)
        self.message = cmd.args.message
        self.name = cmd.args.name
      end
      
      def handle        
        Bbs.with_a_board(self.name, client) do |board|
          post = BbsPost.create(bbs_board: board, 
            subject: self.subject, 
            message: self.message, author: client.char)
          Global.client_monitor.emit_all "New message %xh#{self.subject}%xn posted to %xh#{board.name}%xn by %xh#{client.name}%xn"
        end
      end
    end
  end
end