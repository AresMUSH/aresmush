module AresMUSH
  module Login
    class LoginNoticeMarkReadRequestHandler
      def handle(request)      
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        id = request.args[:id]
        unread = (request.args[:unread] || "").to_bool
        
        notice = enactor.login_notices.select { |n| n.id == id }.first
        if (!notice)
          return { error: t('webportal.not_found') }
        end
        
        notice.update(is_unread: unread)
        
        {}
      end
    end
  end
end