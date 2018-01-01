module AresMUSH
  module Bbs
    class AddPostRequestHandler
      def handle(request)
                
        char_id = request.args[:char_id]
        category_id = request.args[:category_id]
        message = request.args[:message]
        subject = request.args[:subject]
        
        category = BbsBoard[category_id.to_i]
        if (!category)
          return { error: "Category not found." }
        end
        
        if (char_id)
          char = Character.find_one_by_name(char_id)
          if (!char)
            return { error: "Character not found." }
          end
        else
          char = nil
        end

        if (!Bbs.can_write_board?(char, category))
          return { error: "You don't have access to that board." }
        end
        
        if (message.blank? || subject.blank?)
          return { error: "Subject and message are required."}
        end
      
        formatted_message = WebHelpers.format_input_for_mush(message)
        post = Bbs.post(category.name, subject, message, char)
        
        if (!post)
          return { error: "Something went wrong posting the message." }
        end
        
        { id: post.id }
      end
    end
  end
end