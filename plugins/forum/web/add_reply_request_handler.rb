module AresMUSH
  module Forum
    class AddReplyRequestHandler
      def handle(request)
                
        topic_id = request.args[:topic_id]
        message = request.args[:reply]
        author = Character.find_one_by_name(request.args[:author_id])
        enactor = request.enactor
        
        request.log_request
        
        topic = BbsPost[topic_id.to_i]
        if (!topic)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (!author)
          author = enactor
        end
        
        category = topic.bbs_board
        if (!Forum.can_write_to_category?(author, category))
          return { error: t('forum.cannot_access_category') }
        end
        
        if (message.blank?)
          return { error: t('webportal.missing_required_fields' )}
        end
      
        formatted_message = Website.format_input_for_mush(message)
        Forum.reply(category, topic, author, formatted_message)
        {}
      end
    end
  end
end