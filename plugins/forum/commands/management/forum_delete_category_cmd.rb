module AresMUSH
  module Forum
    class ForumDeleteCategoryCmd
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
      
      def handle
        Forum.with_a_category(self.name, client, enactor) do |category|
          client.program[:delete_forum] = category
          
          template = BorderedDisplayTemplate.new t('forum.category_confirm_delete', :category => category.name)
          client.emit template.render
        end
      end
    end
  end
end
