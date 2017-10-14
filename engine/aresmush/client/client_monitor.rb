module AresMUSH
  class ClientMonitor
    def initialize(client_factory)
      @clients = []
      @client_factory = client_factory
    end

    attr_reader :clients, :client_id

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
    
    # trigger_block is a block that tells whether a particular web client
    # should receive a notification based on their character.  
    # 
    # If you want everyone to receive the notice, pass a block that always
    # returns true.
    #     notify_web_clients(type, msg) do |char|
    #        true
    #     end
    #
    # If you want to only notify clients that can do something, pass a block
    # that checks a method based on the character.
    #
    #    notify_web_clients(type, msg) do |char|
    #        char.can_do_something?
    #    end
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
        Global.dispatcher.queue_event CharDisconnectedEvent.new(client, client.find_char.id)
      end        
    end
    
    def logged_in_clients
      @clients.select { |c| c.logged_in? }
    end
    
    def logged_in
      players = {}
      @clients.each do |c|
        char = c.find_char
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