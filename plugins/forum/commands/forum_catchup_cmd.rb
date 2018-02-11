module AresMUSH
  module Forum
    class ForumCatchupCmd
      include CommandHandler
      
      attr_accessor :category_name
      
      def parse_args
        self.category_name = cmd.args ? titlecase_arg(cmd.args) : "All"
      end

      def handle
        if (self.category_name == "All")
          BbsBoard.all.each do |b|
            catchup_category(b)
          end
          client.emit_success t('forum.caught_up_all')
        else
          Forum.with_a_category(self.category_name, client, enactor) do |category|  
            catchup_category(category)
            client.emit_success t('forum.caught_up', :category => category.name)
          end
        end
      end
      
      def catchup_category(category)
        category.unread_posts(enactor).each do |p|
          Forum.mark_read_for_player(enactor, p)
        end
      end
    end
  end
end