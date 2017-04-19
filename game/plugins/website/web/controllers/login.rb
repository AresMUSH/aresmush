module AresMUSH
  class WebApp    
    
    get '/login' do
      erb :login
    end  
    
    get "/logout" do
      session.clear
      redirect to('/')
    end
    
    post '/login' do
      name = params[:name]
      pw = params[:password]
      char = Character.find_one_by_name(name)
      
      
      if (!char || !char.compare_password(pw))
        flash[:error] = "Invalid name or password."
        redirect '/login'
      else
        session[:user_id] = char.id
        char.update(login_api_token: Character.random_link_code)
        flash[:info] = "Welcome, #{char.name}!"
        redirect '/'
      end
    end
  end
end
