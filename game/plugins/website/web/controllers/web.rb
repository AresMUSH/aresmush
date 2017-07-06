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
      @events = Events.upcoming_events
      @calendar = Events.calendar_view_url
      erb :"index"
    end  
    
    get "/play" do
      erb :"play"
    end
    
  end
end
