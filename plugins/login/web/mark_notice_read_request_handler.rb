module AresMUSH
  module Login
    class LoginNoticeMarkReadRequestHandler
      def handle(request)      
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        id = request.args[:id]
        unread = (request.args[:unread] || "").to_bool
        
        notice = LoginNotice[id]
        if (!notice.can_view?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        notice.update(is_unread: unread)
        
        {}
      end
    end
  end
end