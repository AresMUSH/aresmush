module AresMUSH
  module AresCentral
    class HandleLinkRequestHandler
      def handle(request)
        enactor = request.enactor
        handle_name = (request.args[:handle_name] || "").titlecase
        link_code = request.args[:link_code]
        pw = request.args[:confirm_password]

        error = Website.check_login(request)
        return error if error
        
        if enactor.handle
          return { error: t('arescentral.character_already_linked') }
        end
        
        if (!enactor.compare_password(pw))
          return { error: t('login.invalid_password') }
        end
        
        error = AresCentral.link_handle(enactor, handle_name, link_code)
        return { error: error } if error

        {
          handle: handle_name
        }
      end
    end
  end
end