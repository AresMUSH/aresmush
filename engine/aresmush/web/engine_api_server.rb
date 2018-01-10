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
      set :threaded, false #false
      enable :cross_origin
    end    
    
    before do
       response.headers['Access-Control-Allow-Origin'] = '*'
     end
  
     # routes...
     options "*" do
       
       website_url = "#{Global.read_config("server", "hostname")}:#{Global.read_config("server", "web_portal_port")}"
       response.headers["Allow"] = "GET, POST, OPTIONS"
       response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
       response.headers["Access-Control-Allow-Origin"] = website_url
       
       pp request
       puts request.env['HTTP_ORIGIN']
       puts "http://#{website_url}"
       
       if (request.env['HTTP_ORIGIN'] == "http://#{website_url}" ||
           request.env['HTTP_ORIGIN'] == "https://#{website_url}")
           response.headers["Access-Control-Allow-Origin"] =  request.env['HTTP_ORIGIN']
         end
           
       200
     end
     
     get '/api-key/?' do 
       { key: Game.master.engine_api_key }.to_json
     end
     
     post '/request/?' do
       content_type :json
       AresMUSH.with_error_handling(nil, "Web Request") do
         request = WebRequest.new(params)
         if (!request.check_api_key)
           return { error: "Invalid authentication key." }.to_json
         end
         
         response = Global.dispatcher.on_web_request(request)
         return response.to_json
       end
       return { error: "Sorry, something went wrong with the web request." }.to_json
     end
     
     post '/upload/?' do 
       puts params.inspect
     end
    
  end
end