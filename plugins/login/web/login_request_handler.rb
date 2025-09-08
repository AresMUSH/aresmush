module AresMUSH
  module Login
    class LoginRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args['name']
        pw = request.args['password']
        char = Character.find_one_by_name(name)

        error = Website.check_login(request, true)
        return error if error
        
        if (!char)
          return { error: t('login.invalid_name_or_password') }
        end

        if (pw == "ALT")
          if (!enactor || !AresCentral.alts(enactor).include?(char))
            return { error: t('webportal.only_switch_arescentral_alts') }
          end
        else
          result = Login.check_login_allowed_status(char, pw, request.ip_addr, request.hostname)
        
          if result[:status] == 'error'
            return { error: result[:error] }
          end
        end
                  
        if (char.login_token_expired?)
          char.set_login_token
        else
          char.extend_login_token
        end
        
        Login.update_site_info(request.ip_addr, request.hostname, char)
        
        char.update(login_failures: 0)
        char.update(boot_timeout: nil)
        
        Login.announce_connection(nil, char)
        
        Login.web_session_info(char)
      end
    end
  end
end