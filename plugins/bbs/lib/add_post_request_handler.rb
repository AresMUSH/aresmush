module AresMUSH
  module Bbs
    class AddPostRequestHandler
      def handle(request)
                
        category_id = request.args[:category_id]
        message = request.args[:message]
        subject = request.args[:subject]
        enactor = request.enactor

        error = WebHelpers.check_login(request)
        return error if error
        
        category = BbsBoard[category_id.to_i]
        if (!category)
          return { error: "Category not found." }
        end

        if (!Bbs.can_write_board?(enactor, category))
          return { error: "You don't have access to that board." }
        end
        
        if (message.blank? || subject.blank?)
          return { error: "Subject and message are required."}
        end
      
        formatted_message = WebHelpers.format_input_for_mush(message)
        post = Bbs.post(category.name, subject, message, enactor)
        
        if (!post)
          return { error: "Something went wrong posting the message." }
        end
        
        { id: post.id }
      end
    end
  end
end