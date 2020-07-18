module AresMUSH
  module Forum
    class ForumPinCmd
      include CommandHandler
      
      attr_accessor :category_name, :num, :option
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_arg2_equals_arg3)
        self.category_name = titlecase_arg(args.arg1)
        self.num = integer_arg(args.arg2)
        self.option = OnOffOption.new(args.arg3)
      end
      
      def required_args
        [ self.category_name, self.num ]
      end
      
      def check_status
        return self.option.validate
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Forum.can_manage_forum?(enactor)
        return nil
      end
      
      def handle
        Forum.with_a_post(self.category_name, self.num, client, enactor) do |category, post|      
          post.update(is_pinned: self.option.is_on?)
          if (self.option.is_on?)
            client.emit_success t('forum.message_pinned')
          else
            client.emit_success t('forum.message_unpinned')
          end
        end
      end      
    end
  end
end