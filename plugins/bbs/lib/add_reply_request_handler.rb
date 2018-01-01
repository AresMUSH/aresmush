module AresMUSH
  module Bbs
    class AddReplyRequestHandler
      def handle(request)
                
        topic_id = request.args[:topic_id]
        message = request.args[:reply]
        enactor = request.enactor
        
        topic = BbsPost[topic_id.to_i]
        if (!topic)
          return { error: "Topic not found." }
        end
        
        error = WebHelpers.validate_auth_token(request)
        return error if error
        

        category = topic.bbs_board
        if (!Bbs.can_write_board?(enactor, category))
          return { error: "You don't have access to that board." }
        end
        
        if (message.blank?)
          return { error: "Message is required."}
        end
      
        formatted_message = WebHelpers.format_input_for_mush(message)
        Bbs.reply(category, topic, enactor, formatted_message)
        {}
      end
    end
  end
end