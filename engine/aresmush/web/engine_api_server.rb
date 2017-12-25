module AresMUSH

  class EngineApiLoader

    # Start he reactor
    def run(opts = {})

      # define some defaults for our app
      server  = opts[:server] || 'thin'
      host    = opts[:host]   || '0.0.0.0'
      port    = opts[:port]   || '8181'
      web_app = EngineApiServer
      
      dispatch = Rack::Builder.app do
        map '/' do
          run web_app
        end
      end

      Rack::Server.start({
        app:    dispatch,
        server: server,
        Host:   host,
        Port:   port,
        signals: false,
      })
    end
  end

  class EngineApiServer < Sinatra::Base
    # threaded - False: Will take requests on the reactor thread
    #            True:  Will queue request for background thread
    configure do
      set :threaded, true #false
      enable :cross_origin
      register Sinatra::Reloader
    end    
    
    before do
       response.headers['Access-Control-Allow-Origin'] = '*'
     end
  
     # routes...
     options "*" do
       response.headers["Allow"] = "GET, POST, OPTIONS"
       response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
       response.headers["Access-Control-Allow-Origin"] = "*"
       200
     end
    
     helpers do
       def find_template(views, name, engine, &block)
         views = Plugins.all_plugins.map { |p| File.join(AresMUSH.plugin_path, p, "web", "views") }
         views << AresMUSH.website_views_path
         views.each { |v| super(v, name, engine, &block) }
       end
     end
    
    
    # The actual API methods are defined in the AresCentral plugin.
    
    
  end
end