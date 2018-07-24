module AresMUSH
  module Forum
    class AddReplyRequestHandler
      def handle(request)
                
        topic_id = request.args[:topic_id]
        message = request.args[:reply]
        enactor = request.enactor
        
        topic = BbsPost[topic_id.to_i]
        if (!topic)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        

        category = topic.bbs_board
        if (!Forum.can_write_to_category?(enactor, category))
          return { error: t('forum.cannot_access_category') }
        end
        
        if (message.blank?)
          return { error: t('webportal.missing_required_fields' )}
        end
      
        formatted_message = Website.format_input_for_mush(message)
        Forum.reply(category, topic, enactor, formatted_message)
        {}
      end
    end
  end
end