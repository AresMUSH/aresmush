module AresMUSH
  module Forum
    class ForumPinRequestHandler
      def handle(request)
                
        topic_id = request.args[:topic_id]
        pinned = (request.args[:pinned] || "").to_bool
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        topic = BbsPost[topic_id.to_i]
        if (!topic)
          return { error: t('webportal.not_found') }
        end
        
        if (!Forum.can_manage_forum?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        topic.update(is_pinned: pinned)
        {}
      end
    end
  end
end