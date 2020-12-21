module AresMUSH
  module Forum
    class ForumDeleteTopicRequestHandler
      def handle(request)
                
        topic_id = request.args[:topic_id]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        topic = BbsPost[topic_id.to_i]
        if (!topic)
          return { error: t('webportal.not_found') }
        end
        
        if (!Forum.can_edit_post?(enactor, topic))
          return { error: t('dispatcher.not_allowed') }
        end
        
        topic.delete
        
        {}
      end
    end
  end
end