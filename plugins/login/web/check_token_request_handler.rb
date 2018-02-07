module AresMUSH
  module Login
    class CheckTokenRequestHandler
      def handle(request)
                
        id = request.args[:id]
        token = request.args[:token]
        
        char = Character.find_one_by_name(id)
        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        if (char.is_statue?)
          return { error: t('dispatcher.you_are_statue') }
        end
        
        if (char.is_valid_api_token?(token))
          return { token_valid: true }
        end
        
        { error: t('webportal.session_expired') }        
      end
    end
  end
end