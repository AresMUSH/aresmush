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
        
        if (Login.is_banned?(char, request.ip_addr, request.hostname))
          return { status: 'error',  error: Login.site_blocked_message }
        end
        
        
        if (char.is_statue?)
          return { error: t('dispatcher.you_are_statue') }
        end
        
        if (!char.is_valid_api_token?(token))
          return { error: t('webportal.session_expired') }    
        end
        
        if (Time.now - char.last_on > 86400)
          Login.update_site_info(request.ip_addr, request.hostname, char)
        end
        
        Login.web_session_info(char)
        
      end
    end
  end
end