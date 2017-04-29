module AresMUSH
  class WebApp    
    
    
    get '/register' do
      erb :register
    end
    
    post '/register' do
      name = params[:name]
      pw = params[:password]
      confirm_pw = params[:confirm_password]
      recaptcha_response = params["g-recaptcha-response"]
      
      if (@recaptcha.is_enabled? && !@recaptcha.verify(recaptcha_response))
        flash[:error] = "Please prove you're human first."
        redirect '/register'
      end
      
      name_error = Character.check_name(name)
      password_error = Character.check_password(pw)
      
      if (pw != confirm_pw)
        flash[:error] = "Passwords don't match."
        redirect '/register'
      elsif name_error
        flash[:error] = name_error
        redirect '/register'
      elsif password_error
        flash[:error] = password_error
        redirect '/register'
      else 
        char = Character.new
        char.name = name
        char.change_password(pw)
        char.room = Game.master.welcome_room
        char.login_api_token = Character.random_link_code
        char.login_api_token_expiry = Time.now + 86400
        char.save
        
        connection = HeadlessConnection.new(request.ip)
        client = Client.new(0, connection)
        Global.dispatcher.queue_event CharCreatedEvent.new(client, char)
        
        session[:user_id] = char.id
        flash[:info] = "Welcome, #{char.name}!"
        
        redirect '/'
      end
      
    end
  end
end
