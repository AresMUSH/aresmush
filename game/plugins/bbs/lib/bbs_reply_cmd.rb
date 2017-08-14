module AresMUSH
  module Bbs
    class BbsReplyCmd
      include CommandHandler
      
      attr_accessor :board_name, :num, :reply

      def parse_args        
        if (cmd.args =~ /.+\/.+\=.+/)
          args = cmd.parse_args( /(?<name>[^\=]+)\/(?<num>[^\=]+)\=(?<reply>.+)/)
          self.board_name = titlecase_arg(args.name)
          self.num = trim_arg(args.num)
          self.reply = args.reply
        elsif (cmd.args =~ /.+\=.+\/.+/)
          args = cmd.parse_args( /(?<name>[^\=]+)\=(?<num>[^\=]+)\/(?<reply>.+)/)
          self.board_name = titlecase_arg(args.name)
          self.num = trim_arg(args.num)
          self.reply = args.reply
        else
          self.reply = cmd.args
        end
      end
      
      def required_args
        [ self.reply ]
      end
      
      def handle
        post = client.program[:last_bbs_post]
        if (!self.board_name && post)
          board = post.bbs_board
          Bbs.reply(board, post, enactor, self.reply, client)
        else
          if (!self.board_name || !self.num)
            client.emit_failure t('dispatcher.invalid_syntax', :command => 'bbs')
            return
          end
          Bbs.with_a_post(self.board_name, self.num, client, enactor) do |board, post|
            Bbs.reply(board, post, enactor, self.reply, client)
          end
        end
      end
      
      
    end
  end
end