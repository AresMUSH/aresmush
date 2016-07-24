# Based on example by Eric Terry - <a href="https://github.com/eterry1388/sinatra-faye-example">View on GitHub</a>

module AresMUSH

  # Our simple hello-world app
  class WebApp < Sinatra::Base
    # threaded - False: Will take requests on the reactor thread
    #            True:  Will queue request for background thread
    # ...
    register Sinatra::CrossOrigin
  
    configure do
      set :port, 9292
      set :faye_client, Faye::Client.new( 'http://localhost:9292/faye' )
      set :saved_data, []
      set :game_data, []
      set :who_data, { last_updated: "Never", who: [] }
      set :help_data,  { topics: [], current_topic: "" }


      set :threaded, false
      enable :cross_origin

      Faye::WebSocket.load_adapter 'thin'
      use Faye::RackAdapter, mount: '/faye', timeout: 45, extensions: []
    end

    get '/' do
      # This loads the saved data so if the web page is refreshed
      # or a new client connects, the data persists.
      @saved_data = settings.saved_data
      @game_data = settings.game_data
      @who_data = settings.who_data
      @help_data = settings.help_data
    
      erb :index
    end

    post '/chat' do
      channel = params['channel']
      message = params['message']
   
      response = { :channel => channel, :message => message }
      puts "Chat from #{channel}: #{message}."
      settings.faye_client.publish( '/chat', response )

      # Save data for future clients
      settings.saved_data << response
    end
  
    post '/game' do
      message = params['message']
      puts "Room message: #{message}."
      settings.faye_client.publish( '/room', message )
      settings.game_data << message

      settings.faye_client.publish( '/notice', { type: "test", message: "A notice!" } )
    end
  
    post '/who' do
      EM.defer do
      
        who_list = Global.client_monitor.logged_in_clients.map { |c| c.name }
        data = { last_updated: Time.now, who: who_list }
    
        settings.who_data = data
        template = erb(:who_list, :layout => false, :locals => { :who_data => data })
        settings.faye_client.publish( '/who', template )
      end
    end
    
    post '/help' do
      EM.defer do
        puts "Got Help"
        
        help_topics = [ "A", "B", "C" ]
        data = { topics: help_topics, current_topic: "" }
    
        settings.help_data = data
        puts "Got Help #{data}"
        
        template = erb(:help_list, :layout => false, :locals => { :help_data => data })
        settings.faye_client.publish( '/help', template )
      end
    end
  
    post '/create' do
      EM.defer do
        message = params['char']
        puts "Got chargen #{message}"
        
        response = { status: "OK", char: "Bob" }
        response.to_json
     end
     response = { status: "ERR", char: "Fred" }
     response.to_json
    end
  
    get '/test1' do
      response = { status: "ERR", char: "Fred" }
      response.to_json
    end
    
    get '/test2' do
      sleep(10)
      response = { status: "ERR", char: "Bob" }
      response.to_json
    end
    
    def connect_and_send

      host = "localhost"
      port = 4201

      puts "Sending API command to #{host} #{port}."

      Timeout.timeout(15) do
        socket = TCPSocket.new host, port      
        sleep 10
      
        socket.puts "who\r\n"

        line = socket.gets  
      
        puts "Got response #{line}"
        line
      end
    end
  
  end

end