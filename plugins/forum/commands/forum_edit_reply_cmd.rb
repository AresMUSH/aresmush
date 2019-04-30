module AresMUSH
  module Forum
    class ForumEditReplyCmd
      include CommandHandler
      
      attr_accessor :category_name, :post_num, :reply_num, :new_text

      def parse_args        
        args = cmd.parse_args( /(?<name>[^\/]+)\/(?<post_num>[^\/]+)\/(?<reply_num>[^\=]+)=(?<new_text>.+)/)
        self.category_name = trim_arg(args.name)
        self.post_num = trim_arg(args.post_num)
        self.reply_num = integer_arg(args.reply_num)
        self.new_text = args.new_text
      end
      
      def required_args
        [ self.category_name, self.post_num, self.reply_num, self.new_text ]
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
          
          Forum.edit_reply(reply, enactor, self.new_text)
          client.emit_success t('forum.reply_edited')
        end
      end
    end
  end
end