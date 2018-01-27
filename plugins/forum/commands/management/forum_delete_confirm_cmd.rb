module AresMUSH
  module Forum
    class ForumDeleteCategoryConfirmCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Forum.can_manage_forum?(enactor)
        return nil
      end
      
      def handle
        category = client.program[:delete_forum]
        
        if (!category)
          client.emit_failure t('forum.no_delete_in_progress')
          return
        end
        
        Forum.with_a_category(category.name, client, enactor) do |category|
          category.delete
          client.program.delete(:delete_forum)          
          client.emit_success t('forum.category_deleted', :category => category.name)
        end
      end
    end
  end
end
