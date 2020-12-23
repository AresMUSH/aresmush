module AresMUSH
  module Forum
    class ForumEditTopicRequestHandler
      def handle(request)
                
        topic_id = request.args[:topic_id]
        enactor = request.enactor
        message = Website.format_input_for_mush(request.args[:message] || "")
        subject = request.args[:subject]
        
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
        
        Forum.edit_post(topic, enactor, subject, message)
        
        {
          message: topic.message
        }
      end
    end
  end
end