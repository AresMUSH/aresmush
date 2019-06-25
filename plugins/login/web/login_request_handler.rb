module AresMUSH
  module Login
    class LoginRequestHandler
      def handle(request)
                
        name = request.args[:name]
        pw = request.args[:password]
        char = Character.find_one_by_name(name)
                    
        if (!char)
           return { error: t('login.invalid_name_or_password') }
        elsif (char.is_guest?)
          return { error: t('login.no_guest_webportal') }
        end

        result = Login.check_login(char, pw, request.ip_addr, request.hostname)
        
        if result[:status] == 'error'
          return { error: result[:error] }
        end
                  
        if (char.login_token_expired?)
          char.set_login_token
        else
          char.extend_login_token
        end
        
        Login.update_site_info(request.ip_addr, request.hostname, char)
        
        if (char.handle)
          AresCentral.sync_handle(char)
        end
        
        {
          token: char.login_api_token,
          name: char.name,
          id: char.id,
          is_approved: char.is_approved?,
          is_admin: char.is_admin?,
          is_coder: char.is_coder?
        }
      end
    end
  end
end