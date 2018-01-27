module AresMUSH
  module Forum
    class AddReplyRequestHandler
      def handle(request)
                
        topic_id = request.args[:topic_id]
        message = request.args[:reply]
        enactor = request.enactor
        
        topic = BbsPost[topic_id.to_i]
        if (!topic)
          return { error: "Topic not found." }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        

        category = topic.bbs_board
        if (!Forum.can_write_to_category?(enactor, category))
          return { error: "You don't have access to that category." }
        end
        
        if (message.blank?)
          return { error: "Message is required."}
        end
      
        formatted_message = WebHelpers.format_input_for_mush(message)
        Forum.reply(category, topic, enactor, formatted_message)
        {}
      end
    end
  end
end