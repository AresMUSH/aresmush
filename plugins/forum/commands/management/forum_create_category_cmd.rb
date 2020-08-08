module AresMUSH
  module Forum
    class ForumCreateCategoryCmd
      include CommandHandler
           
      attr_accessor :name

      def parse_args
        self.name = trim_arg(cmd.args)
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
        approved_role = Role.find_one_by_name('approved')
        forum = BbsBoard.create(name: self.name, order: BbsBoard.all.count + 1)
        if (approved_role)
          forum.write_roles.add approved_role
        end
        client.emit_success t('forum.category_created')
      end
    end
  end
end
