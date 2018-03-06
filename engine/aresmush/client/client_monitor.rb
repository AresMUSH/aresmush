module AresMUSH
  class ClientMonitor
    def initialize(client_factory)
      @clients = []
      @client_factory = client_factory
    end

    attr_reader :clients, :client_id

    def emit_all(msg, &trigger_block)
      @clients.each do |c|
        if ( yield c.char )
          c.emit msg
        end
      end
    end
    
    def emit_all_ooc(msg, &trigger_block)
      @clients.each do |c|
        if ( yield c.char )
          c.emit_ooc msg
        end
      end
    end
    
    def emit_if_logged_in(char, message)
      client = find_client(char)
      if (client)
        client.emit message
      end
    end
    
    def emit_ooc_if_logged_in(char, message)
      client = find_client(char)
      if (client)
        client.emit_ooc message
      end
    end
    
    def notify_web_clients(type, msg, &trigger_block)
      @clients.each do |c|        
        if ( yield Character[c.web_char_id] )
          c.web_notify type, msg
        end
      end
    end

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
    
    def connection_closed(client)
      @clients.delete client
      Global.dispatcher.queue_event ConnectionClosedEvent.new(client)
      if (client.logged_in?)
        Global.dispatcher.queue_event CharDisconnectedEvent.new(client, client.char.id)
      end        
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
  end
end
