module AresMUSH
  module Bbs
    class BbsPostCmd
      include CommandHandler
      
      attr_accessor :board_name, :subject, :message
      
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