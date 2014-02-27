module AresMUSH

  class Client 

    attr_reader :ip_addr, :id
    attr_accessor :char
    
    def initialize(id, connection)
      @id = id
      @connection = connection
    end
    
    def to_s
      "Name=#{name} ID=#{id}"
    end
    
    def connected
      ClientGreeter.greet(self)
    end

    def ping
      @connection.ping
    end
    
    def emit(msg)
      @connection.send_formatted msg
    end 
    
    def emit_ooc(msg)
      @connection.send_formatted "%xc%% #{msg}%xn"
    end

    def emit_success(msg)
      @connection.send_formatted "%xg%% #{msg}%xn"
    end

    def emit_failure(msg)
      @connection.send_formatted "%xr%% #{msg}%xn"
    end

    def idle
      # TODO - Implement idle command
      "3m"
    end
    
    # Initiates a disconnect on purpose.  Wait a tick
    # to give any pending messages a chance to flush.
    def disconnect
      EM.next_tick { @connection.close_connection }
    end
    
    def handle_input(input)
      begin
        Global.dispatcher.on_command(self, Command.new(input))
      rescue Exception => e
        Global.logger.error("Error handling input: client=#{self} input=#{input} error=#{e} backtrace=#{e.backtrace[0,10]}")
      end
    end

    # Responds to a disconnect from any sort of source - socket error, client-initated, etc.
    def connection_closed
      Global.client_monitor.connection_closed self
    end
    
    # In general, we want to avoid duplicating character interfaces on the client, but 
    # these two (name and room) are used so ubiquitously that they're an exception.
    def name
      @char.nil? ? t('client.anonymous'): @char.name
    end
    
    def room
      @char.nil? ? nil : @char.room
    end
    
    def logged_in?
      !@char.nil?
    end
  end
end