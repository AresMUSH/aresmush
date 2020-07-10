module AresMUSH
  module Login
    class LoginRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args[:name]
        pw = request.args[:password]
        char = Character.find_one_by_name(name)

        error = Website.check_login(request, true)
        return error if error
        
        if (!char)
          if (name && name.downcase.start_with?("guest"))
            return { error: t('login.no_guest_webportal') }
          else
           return { error: t('login.invalid_name_or_password') }
          end
        elsif (char.is_guest?)
          return { error: t('login.no_guest_webportal') }
        end

        if (pw == "ALT")
          if (!enactor || !AresCentral.alts(enactor).include?(char))
            return { error: t('webportal.only_switch_arescentral_alts') }
          end
        else
          result = Login.check_login(char, pw, request.ip_addr, request.hostname)
        
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
        
        if (char.handle)
          AresCentral.sync_handle(char)
        end
        
        {
          token: char.login_api_token,
          name: char.name,
          id: char.id,
          is_approved: char.is_approved?,
          is_admin: char.is_admin?,
          is_coder: char.is_coder?,
          is_wiki_mgr: (!char.is_admin? && Website.can_manage_theme?(char))
        }
      end
    end
  end
end