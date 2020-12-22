module AresMUSH
  module Forum
    class ForumEditReplyRequestHandler
      def handle(request)
                
        reply_id = request.args[:reply_id]
        message = Website.format_input_for_mush(request.args[:message] || "")
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        reply = BbsReply[reply_id.to_i]
        if (!reply)
          return { error: t('webportal.not_found') }
        end
        
        if (!Forum.can_edit_post?(enactor, reply))
          return { error: t('dispatcher.not_allowed') }
        end
        
        Forum.edit_reply(reply, enactor, message)
        
        {
          message: Website.format_markdown_for_html(reply.message)
        }
      end
    end
  end
end