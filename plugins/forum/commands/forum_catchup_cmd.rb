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
            Forum.catchup_category(enactor, b)
          end
          client.emit_success t('forum.caught_up_all')
        else
          Forum.with_a_category(self.category_name, client, enactor) do |category|  
            Forum.catchup_category(enactor, category)
            client.emit_success t('forum.caught_up', :category => category.name)
          end
        end
      end

    end
  end
end