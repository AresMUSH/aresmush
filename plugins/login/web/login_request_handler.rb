module AresMUSH
  module Login
    class LoginRequestHandler
      def handle(request)
                
        name = request.args[:name]
        pw = request.args[:password]
        char = Character.find_one_by_name(name)
            
        if (!char || !char.compare_password(pw))
          return { error: t('login.invalid_name_or_password') }
        elsif (char.is_guest?)
          return { error: t('login.no_guest_webportal') }
        elsif (char.is_statue?)
          return { error: t('dispatcher.you_are_statue') }
        end
        
        if (char.login_token_expired?)
          char.set_login_token
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