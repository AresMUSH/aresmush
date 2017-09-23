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
      request_parts = request.path_info.split("/")
      @page_title = request_parts.empty? ? 
           "Home - #{game_name}" : 
           "#{request_parts[-1].titleize} - #{game_name}"
      @sidebar_upcoming_events = Events.upcoming_events[0..5]
      @sidebar_recent_wiki = unique_recent_page_changes[0..9]
      @sidebar_recent_scenes = Scene.all.select { |s| s.shared }.sort_by { |s| s.date_shared || s.created_at }.reverse[0..9] || []
      @sidebar_recent_profiles = Character.all.to_a.sort_by{ |c| c.profile_last_edited || c.created_at }.reverse[0..5]
      
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
      
      def char_page_url(char)
        "/char/#{char.name.downcase}"
      end
    end

    get '/' do
      @website_welcome = Global.read_config('website', 'website_welcome')
      @website_tagline = Global.read_config('website', 'website_tagline')
      erb :"index"
    end  
    
    get "/play/?" do
      erb :"play"
    end
    
    get '/styles/:name.css' do |name|
      content_type 'text/css', :charset => 'utf-8'
      scss(:"styles/#{name}", Compass.sass_engine_options )
    end
    
    get '/who/?' do
      @who =  Global.client_monitor.logged_in.map { |client, char| char }
      @scenes = Scene.all.select { |s| !s.completed }
      erb :"who"
    end
    
  end
end
