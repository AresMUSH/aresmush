module AresMUSH
  module Forum
    class ForumDeleteReplyRequestHandler
      def handle(request)
                
        reply_id = request.args[:reply_id]
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
        
        reply.delete
        
        {}
      end
    end
  end
end