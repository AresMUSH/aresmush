module AresMUSH
  
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
    # threaded - False: Will take requests on the reactor thread
    #            True:  Will queue request for background thread
    configure do
      set :threaded, false
      register Sinatra::Reloader
    end

    helpers do
      def find_template(views, name, engine, &block)
        views = Plugins.all_plugins.map { |p| File.join(PluginManager.plugin_path, p, 'web') }
        views.each { |v| super(v, name, engine, &block) }
      end
    end
  end
end