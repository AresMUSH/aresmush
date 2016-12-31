module AresMUSH
  module Bbs
    class BbsDeleteReplyCmd
      include CommandHandler
      
      attr_accessor :board_name, :post_num, :reply_num

      def crack!        
        cmd.crack_args!(ArgParser.arg1_slash_arg2_equals_arg3)
        self.board_name = cmd.args.arg1
        self.post_num = cmd.args.arg2
        self.reply_num = cmd.args.arg3 ? cmd.args.arg3.to_i : 0
      end
      
      def required_args
        {
          args: [ self.board_name, self.post_num, self.reply_num ],
          help: 'bbs'
        }
      end
      
      def handle
        Bbs.with_a_post(self.board_name, self.post_num, client, enactor) do |board, post|
          reply = post.bbs_replies.to_a[self.reply_num - 1]
          if (self.reply_num <= 0 || !reply)
            client.emit_failure t('bbs.invalid_reply_number')
            return
          end
          if (!Bbs.can_edit_post(enactor, reply))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          reply.delete
          client.emit_success t('bbs.reply_deleted')
        end
      end
    end
  end
end