module AresMUSH
  module AresCentral
    class HandleLinkRequestHandler
      def handle(request)
        enactor = request.enactor
        handle_name = (request.args[:handle_name] || "").titlecase
        link_code = request.args[:link_code]

        error = Website.check_login(request)
        return error if error
        
        if enactor.handle
          return { error: t('arescentral.character_already_linked') }
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