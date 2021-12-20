module AresMUSH
  module Login
    class BanAddRequestHandler
      def handle(request)
        enactor = request.enactor
        site = request.args[:site]
        reason = request.args[:reason]
        
        error = Website.check_login(request)
        return error if error
        
        if !enactor.is_admin?
          return { error: t('dispatcher.not_allowed') }
        end

        if (site.blank? || reason.blank?)
          return { error: t('webportal.missing_required_fields') }
        end

        error = Login.add_site_ban(enactor, site, reason)
        if (error) 
          return { error: error }  
        end
        
        {}
      end
    end
  end
end