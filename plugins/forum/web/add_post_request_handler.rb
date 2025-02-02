module AresMUSH
  module Forum
    class AddPostRequestHandler
      def handle(request)
                
        category_id = request.args['category_id']
        message = request.args['message']
        subject = request.args['subject']
        author = Character.find_one_by_name(request.args['author_id']) || enactor
        enactor = request.enactor

        error = Website.check_login(request)
        return error if error
        
        request.log_request        
        
        if !AresCentral.is_alt?(enactor, author)
          return { error: t('dispatcher.not_allowed') }
        end
        
        category = BbsBoard[category_id.to_i]
        if (!category)
          return { error: t('webportal.not_found') }
        end

        if (!Forum.can_write_to_category?(author, category))
          return { error: t('forum.cannot_access_category') }
        end
        
        if (message.blank? || subject.blank?)
          return { error: t('webportal.missing_required_fields', :fields => "message, subject") }
        end
      
        formatted_message = Website.format_input_for_mush(message)
        post = Forum.post(category.name, subject, message, author)
        
        if (!post)
          return { error: t('webportal.unexpected_error') }
        end
        
        { id: post.id }
      end
    end
  end
end