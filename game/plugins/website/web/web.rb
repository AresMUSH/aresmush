module AresMUSH
  class WebApp    
    attr_accessor :user
    
    before do
      user_id = session[:user_id]
      @user = user_id ? Character[user_id] : nil
      @recaptcha = AresMUSH::Website::RecaptchaHelper.new
    end
    
    helpers do
      def is_user?
        @user != nil
      end
      
      def is_admin?
        @user != nil && @user.is_admin?
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
    
    get "/play" do
      erb :play
    end
    
  end
end
