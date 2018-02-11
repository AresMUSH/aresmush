module AresMUSH
  module Forum
    class ForumReplyCmd
      include CommandHandler
      
      attr_accessor :category_name, :num, :reply

      def parse_args        
        if (cmd.args =~ /.+\/.+\=.+/)
          args = cmd.parse_args( /(?<name>[^\=]+)\/(?<num>[^\=]+)\=(?<reply>.+)/)
          self.category_name = titlecase_arg(args.name)
          self.num = trim_arg(args.num)
          self.reply = args.reply
        elsif (cmd.args =~ /.+\=.+\/.+/)
          args = cmd.parse_args( /(?<name>[^\=]+)\=(?<num>[^\=]+)\/(?<reply>.+)/)
          self.category_name = titlecase_arg(args.name)
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
        post = client.program[:last_forum_post]
        if (!self.category_name && post)
          category = post.bbs_board
          Forum.reply(category, post, enactor, self.reply, client)
        else
          if (!self.category_name || !self.num)
            client.emit_failure t('dispatcher.invalid_syntax', :cmd => 'forum')
            return
          end
          Forum.with_a_post(self.category_name, self.num, client, enactor) do |category, post|
            Forum.reply(category, post, enactor, self.reply, client)
          end
        end
      end
      
      
    end
  end
end