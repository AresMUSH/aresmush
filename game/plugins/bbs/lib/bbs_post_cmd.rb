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
          cmd.crack!(/(?<name>[^\=]+)=(?<subject>[^\/]+)\/(?<message>.+)/)
        else
          cmd.crack!(/(?<name>[^\/]+)\/(?<subject>[^\=]+)\=(?<message>.+)/)
        end
        self.board_name = trim_input(cmd.args.name)
        self.subject = trim_input(cmd.args.subject)
        self.message = cmd.args.message
      end
      
      def handle        
        Bbs.with_a_board(self.board_name, client) do |board|
          post = BbsPost.create(bbs_board: board, 
            subject: self.subject, 
            message: self.message, author: client.char)
          Global.client_monitor.emit_all t('bbs.new_post', :subject => self.subject, :board => self.board_name, :author => client.name)
        end
      end
    end
  end
end