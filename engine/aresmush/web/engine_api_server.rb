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
    end    
    
    # The actual API methods are defined in the AresCentral plugin.
  end
end