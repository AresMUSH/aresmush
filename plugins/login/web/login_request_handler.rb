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
        char.update(login_api_token: "#{SecureRandom.uuid}")
        char.update(login_api_token_expiry: Time.now + 86400)
        {
          token: char.login_api_token,
          name: char.name,
          id: char.id,
          is_approved: char.is_approved?,
          is_admin: char.is_admin?
        }
      end
    end
  end
end