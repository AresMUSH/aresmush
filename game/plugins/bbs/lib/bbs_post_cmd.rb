module AresMUSH
  module Bbs
    class BbsPostCmd
      include CommandHandler
      
      attr_accessor :board_name, :subject, :message
      
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
          help: 'bbs'
        }
      end
      
      def handle        
        Bbs.post(self.board_name, self.subject, self.message, enactor, client)
      end
    end
  end
end