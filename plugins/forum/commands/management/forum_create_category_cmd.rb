module AresMUSH
  module Forum
    class ForumCreateCategoryCmd
      include CommandHandler
           
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Forum.can_manage_forum?(enactor)
        return nil
      end
      
      def check_category_exists
        return nil if !self.name
        category = BbsBoard.all_sorted.find { |b| b.name.upcase == self.name.upcase }
        return t('forum.category_already_exists', :name => self.name) if category
        return nil
      end
      
      def handle
        BbsBoard.create(name: self.name, order: BbsBoard.all.count + 1)
        client.emit_success t('forum.category_created')
      end
    end
  end
end
