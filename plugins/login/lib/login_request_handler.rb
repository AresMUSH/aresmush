module AresMUSH
  module Login
    class LoginRequestHandler
      def handle(request)
        
        puts request.inspect
        
        name = request.args[:name]
        pw = request.args[:password]
        char = Character.find_one_by_name(name)
            
        if (!char || !char.compare_password(pw))
          return { message: "Invalid name or password." }
        elsif (char.is_guest?)
          return { message: "Guests do not have a web portal account.  You can still use the 'Play' screen to play with the web client as a guest." }
          redirect '/login'
        elsif (char.is_statue?)
          return { message: "You have been turned into a statue and are locked out of the game." }
        end
        char.update(login_api_token: "#{SecureRandom.uuid}")
        char.update(login_api_token_expiry: Time.now + 86400)
        {
          token: char.login_api_token,
          name: char.name,
          id: char.id
        }
      end
    end
  end
end