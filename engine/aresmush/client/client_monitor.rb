module AresMUSH
  class ClientMonitor
    def initialize(client_factory)
      @clients = []
      @web_event_clients = []
      @client_factory = client_factory      
    end

    attr_reader :clients, :client_id, :web_event_clients

    def emit_all(msg)
      @clients.each do |c|
        c.emit msg
      end
    end
    
    def emit_all_ooc(msg)
      @clients.each do |c|
        c.emit_ooc msg
      end
    end
    
    def emit(msg, &trigger_block)
      @clients.each do |c|
        if ( yield c.char )
          c.emit msg
        end
      end
    end
    
    def emit_ooc(msg)
      @clients.each do |c|
        if ( yield c.char )
          c.emit_ooc msg
        end
      end
    end
    
    def add_web_event_client(char_id, stream) 
      client = WebEventClient.new(char_id, stream)
      @web_event_clients << client
      
      stream.callback {
        @web_event_clients.delete_if { |client| client.stream == stream }
      }
    end
    
    def remove_web_event_client(char)
      @web_event_clients.delete_if { |client| client.char_id == char.id }
    end
    
    def notify_web_clients(type, msg, is_data, &trigger_block)
      Global.dispatcher.spawn("Notifying web clients", nil) do
        @web_event_clients.each do |client|          
          char = client.character
          if ( yield char )
            client.web_notify type, msg, is_data
          end
        end
      end
    end
    
    def ping_web_clients
      @web_event_clients.each do |client|
        client.ping
      end
    end
    
    def web_clients
      @web_event_clients
    end

    def logged_in_clients
      @clients.select { |c| c.logged_in? }
    end
    
    def logged_in
      players = {}
      @clients.each do |c|
        char = c.char
        next if !char
        players[c] = char
      end
      players
    end
    
    def find_client(char)
      @clients.select { |c| c.char_id == char.id }.first
    end
    
    def find_web_client(char)
      @web_event_clients.select { |c| c.char_id == char.id }.first
    end
    
    # @engineinternal true
    def connection_established(connection)
      begin
        client = @client_factory.create_client(connection)
        @clients << client
        client.connected
        Global.dispatcher.queue_event ConnectionEstablishedEvent.new(client)
      rescue Exception => e
        Global.logger.debug "Error establishing connection Error: #{e.inspect}. \nBacktrace: #{e.backtrace[0,10]}"
      end
    end
        
    # @engineinternal true
    def connection_closed(client)
      @clients.delete client
      Global.dispatcher.queue_event ConnectionClosedEvent.new(client)
      if (client.logged_in?)
        Global.dispatcher.queue_event CharDisconnectedEvent.new(client, client.char.id)
      end        
    end
    
  end
end