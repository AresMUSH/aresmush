module AresMUSH
  module Forum
    class ForumDeleteReplyCmd
      include CommandHandler
      
      attr_accessor :category_name, :post_num, :reply_num

      def parse_args        
        args = cmd.parse_args(ArgParser.arg1_slash_arg2_equals_arg3)
        self.category_name = trim_arg(args.arg1)
        self.post_num = trim_arg(args.arg2)
        self.reply_num = args.arg3 ? args.arg3.to_i : 0
      end
      
      def required_args
        [ self.category_name, self.post_num, self.reply_num ]
      end
      
      def handle
        Forum.with_a_post(self.category_name, self.post_num, client, enactor) do |category, post|
          reply = post.bbs_replies.to_a[self.reply_num - 1]
          if (self.reply_num <= 0 || !reply)
            client.emit_failure t('forum.invalid_reply_number')
            return
          end
          if (!Forum.can_edit_post?(enactor, reply))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          reply.delete
          client.emit_success t('forum.reply_deleted')
        end
      end
    end
  end
end