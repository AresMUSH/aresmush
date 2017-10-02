module AresMUSH
  class WebApp    
    
    get '/login/?', :auth => :not_user  do
      @redirect = params[:redirect]
      erb :"login"
    end  
    
    get "/logout/?", :auth => :user do
      session.clear
      redirect to('/')
    end
    
    post '/login', :auth => :not_user  do
      name = params[:name]
      pw = params[:password]
      char = Character.find_one_by_name(name)
            
      if (!char || !char.compare_password(pw))
        flash[:error] = "Invalid name or password."
        redirect '/login'
      elsif (char.is_guest?)
        flash[:error] = "Guests do not have a web portal account.  You can still use the 'Play' screen to play with the web client as a guest."
        redirect '/login'
      else
        char.update(login_api_token: "#{SecureRandom.uuid}")
        char.update(login_api_token_expiry: Time.now + 86400)
        flash[:info] = "Welcome, #{char.name}!"
        session[:user_id] = char.id
        session[:login_token] = char.login_api_token
        redirect params[:redirect] || '/'
      end
    end
  end
end
