module AresMUSH
  module Bbs
    class AddReplyRequestHandler
      def handle(request)
                
        char_id = request.args[:char_id]
        topic_id = request.args[:topic_id]
        message = request.args[:reply]
        
        topic = BbsPost[topic_id.to_i]
        if (!topic)
          return { error: "Topic not found." }
        end
        
        if (char_id)
          char = Character.find_one_by_name(char_id)
          if (!char)
            return { error: "Character not found." }
          end
        else
          char = nil
        end

        category = topic.bbs_board
        if (!Bbs.can_write_board?(char, category))
          return { error: "You don't have access to that board." }
        end
        
        if (message.blank?)
          return { error: "Message is required."}
        end
      
        formatted_message = WebHelpers.format_input_for_mush(message)
        Bbs.reply(category, topic, char, formatted_message)
        {}
      end
    end
  end
end