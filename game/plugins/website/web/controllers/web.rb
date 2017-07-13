module AresMUSH
  class WebApp    
    
    configure do
      disable :show_exceptions      
    end
   
    error do
      Global.logger.error env['sinatra.error']
      @error = env['sinatra.error'].message
      erb :"error"
    end
    
    before "*" do
      @events = Events.upcoming_events
      @calendar = Events.calendar_view_url
      @recent_scenes = Scene.all.select { |s| s.shared }.sort_by { |s| s.created_at }.reverse[0..10] || []
      
    end
      
    helpers do

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

    end

    get '/' do
      @website_welcome = Global.read_config('website', 'website_welcome')
      @website_tagline = Global.read_config('website', 'website_tagline')
      erb :"index"
    end  
    
    get "/play" do
      erb :"play"
    end
    
  end
end
