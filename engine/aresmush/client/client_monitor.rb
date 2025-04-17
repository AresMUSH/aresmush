module AresMUSH
  class ClientMonitor
    def initialize(client_factory)
      @clients = []
      @client_factory = client_factory
    end

    attr_reader :clients, :client_id

    def emit_all(msg)
      self.game_clients.each do |c|
        c.emit msg
      end
    end

    def emit_all_ooc(msg, &trigger_block)
      self.game_clients.each do |c|
        if ( yield c.char )
          c.emit_ooc msg
        end
      end
    end
 
    
    def notify_web_clients(type, msg, is_data, &trigger_block)
      Global.dispatcher.spawn("Notifying web clients", nil) do
        self.web_clients.each do |c|    
          if ( yield c.character )
            c.send_web_notification type, msg, is_data
          end
        end
      end
    end
    
    def all_clients
      @clients
    end
    
    def game_clients
      @clients.select { |c| !c.is_web_client? }
    end
      
    def web_clients
      @clients.select { |c| c.is_web_client? }
    end

    def logged_in_clients
      self.game_clients.select { |c| c.logged_in? }
    end
    
    # Hash mapping client to char - only for logged in game clients.
    def client_to_char_map
      players = {}
      
      self.logged_in_clients.each do |client|
        players[client] = client.char
      end
      players
    end
    
    def find_game_client(char)
      self.game_clients.select { |c| c.char_id == char.id }.first
    end
    
    def find_web_client(char)
      self.web_clients.select { |c| c.char_id == char.id }.sort_by { |c| c.idle_secs }.first
    end
    
    # @engineinternal true
    def connection_established(connection)
      begin
        client = @client_factory.create_client(connection)
        @clients << client
        client.connected
        if (!client.is_web_client?)
          Global.dispatcher.queue_event ConnectionEstablishedEvent.new(client)
        end
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