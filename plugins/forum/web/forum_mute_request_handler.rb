module AresMUSH
  module Forum
    class ForumMuteRequestHandler
      def handle(request)
                
        option = (request.args[:muted] || "").to_bool
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        enactor.update(forum_muted: option)        
        {        
        }
      end
    end
  end
end