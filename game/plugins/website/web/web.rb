module AresMUSH
  class WebApp    
    attr_accessor :user
    
    before do
      user_id = session[:user_id]
      @user = user_id ? Character[user_id] : nil
    end
    
    helpers do
      def is_user?
        @user != nil
      end
      
      def is_admin?
        @user != nil && @user.can_manage_game?
      end
      
      def is_approved?
        @user != nil && @user.is_approved?
      end

      def game_name
        AresMUSH::Global.read_config('game', 'name' )
      end
      
      def game_website
        AresMUSH::Global.read_config('game', 'website' )
      end
      
      def game_address
        host = AresMUSH::Global.read_config('server', 'hostname' )
        port = AresMUSH::Global.read_config('server', 'port' )
        "#{host} port #{port}"
      end

      def format_input_for_mush(input)
        return nil if !input
        input.gsub(/\r\n/, '%r')
      end
      
      def format_input_for_html(input)
        return nil if !input
        input.gsub(/%r/i, '&#013;&#010;')
      end
      
      def titlecase_arg(input)
        return nil if !input
        input.titlecase
      end

    end

    get '/' do
      @events = Events::Api.upcoming_events
      @calendar = Events.calendar_view_url
      erb :index
    end  
    
    get '/login' do
      erb :login
    end  
    
    get "/logout" do
      session.clear
      redirect to('/')
    end
    
    get "/play" do
      erb :play
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
