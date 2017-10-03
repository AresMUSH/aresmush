module AresMUSH
  mattr_accessor :web_server
  
  class WebAppLoader

    # Start he reactor
    def run(opts = {})

      # define some defaults for our app
      server  = opts[:server] || 'thin'
      host    = opts[:host]   || '0.0.0.0'
      port    = opts[:port]   || '8181'
      web_app = WebApp

      # create a base-mapping that our application will set at. If I
      # have the following routes:
      #
      #   get '/hello' do
      #     'hello!'
      #   end
      #
      #   get '/goodbye' do
      #     'see ya later!'
      #   end
      #
      # Then I will get the following:
      #
      #   mapping: '/'
      #   routes:
      #     /hello
      #     /goodbye
      #
      #   mapping: '/api'
      #   routes:
      #     /api/hello
      #     /api/goodbye
      dispatch = Rack::Builder.app do
        map '/' do
          run web_app
        end
      end

      # Start the web server. Note that you are free to run other tasks
      # within your EM instance.
      Rack::Server.start({
        app:    dispatch,
        server: server,
        Host:   host,
        Port:   port,
        signals: false,
      })
    
    
    end
  end

  # Our simple hello-world app
  class WebApp < Sinatra::Base
    def initialize
      AresMUSH::web_server = self
      super
    end
      
    # threaded - False: Will take requests on the reactor thread
    #            True:  Will queue request for background thread
    configure do
      set :threaded, true #false
      register Sinatra::Reloader
      register Sinatra::Flash
      enable :sessions
      set :public_folder, File.join(AresMUSH.game_path, 'plugins', 'website', 'web', 'public')
      
      Compass.configuration do |config|
         config.project_path = File.join(AresMUSH.game_path, 'plugins', 'website', 'web')
         config.sass_dir = 'styles'
       end

       set :sass, Compass.sass_engine_options
       set :scss, Compass.sass_engine_options
    end
    
    register do
      def auth (type)
        condition do
          unless send("is_#{type}?")
            if (type == :admin)
              flash[:error] = "Please log in with an admin account."
            elsif (type == :approved)
              flash[:error] = "You must be approved first."
            else
              flash[:error] = "Please log in first"
            end
            redirect "/" 
          end
        end
      end
    end
    
    helpers do
      def find_template(views, name, engine, &block)
        views = Plugins.all_plugins.map { |p| File.join(PluginManager.plugin_path, p, 'web', 'views') }
        views.each { |v| super(v, name, engine, &block) }
      end
    end
  end
end