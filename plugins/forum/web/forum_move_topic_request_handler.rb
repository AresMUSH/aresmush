module AresMUSH
  module Forum
    class ForumMoveTopicRequestHandler
      def handle(request)
                
        topic_id = request.args[:topic_id]
        category_id = request.args[:category_id]
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        topic = BbsPost[topic_id.to_i]
        if (!topic)
          return { error: t('webportal.not_found') }
        end
        
        category = BbsBoard[category_id.to_i]
        if (!category) 
          return { error: t('webportal.not_found') }
        end
        
        if (!Forum.can_write_to_category?(enactor, category))
          return { error: t('dispatcher.not_allowed') }
        end
        
        topic.update(bbs_board: category)
        {
          post_id: topic.id,
          category_id: category.id
        }
      end
    end
  end
end