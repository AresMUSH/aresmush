module AresMUSH
  module Forum
    class ForumMoveCmd
      include CommandHandler
      
      attr_accessor :category_name, :num, :new_category_name
      
      def parse_args
        args = cmd.parse_args( /(?<name>[^\=]+)\/(?<num>[^\=]+)\=(?<new_category>[^\=]+)/)
        self.category_name = titlecase_arg(args.name)
        self.num = trim_arg(args.num)
        self.new_category_name = trim_arg(args.new_category)
      end
      
      def required_args
        [ self.category_name, self.num, self.new_category_name ]
      end
      
      def handle
        Forum.with_a_post(self.category_name, self.num, client, enactor) do |category, post|
          if (!Forum.can_edit_post?(enactor, post))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          Forum.with_a_category(self.new_category_name, client, enactor) do |new_category|
            Forum.move_topic_to_category(enactor, post, new_category)
            client.emit_success t('forum.post_moved', :subject => post.subject, :category => new_category.name)
          end
        end
      end
    end
  end
end