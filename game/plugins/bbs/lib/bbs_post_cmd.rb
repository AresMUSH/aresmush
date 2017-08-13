module AresMUSH
  module Bbs
    class BbsPostCmd
      include CommandHandler
      
      attr_accessor :board_name, :subject, :message
      
      def help
        "`bbs/post <board name or number>=<title>/<body>` - Writes a new post."
      end
      
      def parse_args
        if (cmd.args =~ /^[^=\/]+=[^\/=]+\/.+/)
          args = cmd.parse_args(/(?<name>[^\=]+)=(?<subject>[^\/]+)\/(?<message>.+)/)
        else
          args = cmd.parse_args(/(?<name>[^\/]+)\/(?<subject>[^\=]+)\=(?<message>.+)/)
        end
        self.board_name = trim_arg(args.name)
        self.subject = trim_arg(args.subject)
        self.message = args.message
      end
      
      def required_args
        {
          args: [ self.board_name, self.subject, self.message ],
          help: 'bbs posting'
        }
      end
      
      def handle   
        if (self.board_name.to_i > 0 && self.subject.to_i > 0)
          Bbs.with_a_post(self.board_name, self.subject, client, enactor) do |board, post|
            Bbs.reply(board, post, enactor, self.message, client)
          end
        else
          Bbs.post(self.board_name, self.subject, self.message, enactor, client)
        end
      end
    end
  end
end