module AresMUSH

  class Client 

    attr_reader :ip_addr, :id, :hostname
    attr_accessor :char_id, :last_activity, :last_connect, :program, :input_buffer
    
    def initialize(id, connection)
      @id = id
      @connection = connection
      self.last_activity = Time.now
      self.last_connect = Time.now
      self.input_buffer = ""
      @ip_addr = @connection.ip_addr
      begin
        @hostname = Resolv.getname @ip_addr
      rescue
        @hostname = ""
      end
      @program = {}
    end
    
    def to_s
      "ID=#{id}"
    end
    
    def connected
      ClientGreeter.greet(self)
    end

    def ping
      @connection.ping
    end
    
    def window_width
      @connection.window_width
    end
    
    def window_height
      @connection.window_height
    end
    
    def enable_fansi
      return false if !@char_id
      char = find_char
      char.fansi_on
    end
    
    def emit(msg)
      @connection.send_formatted "#{msg}", enable_fansi
    end 
    
    def emit_ooc(msg)
      @connection.send_formatted "%xc%% #{msg}%xn", enable_fansi
    end

    def emit_success(msg)
      @connection.send_formatted "%xg%% #{msg}%xn", enable_fansi
    end

    def emit_failure(msg)
      @connection.send_formatted "%xr%% #{msg}%xn", enable_fansi
    end
    
    def emit_raw(msg)
      @connection.send_data "#{msg}\r\n"
    end
    
    def idle_secs
      (Time.now - self.last_activity).to_i
    end
    
    def connected_secs
      (Time.now - self.last_connect).to_i
    end
    
    def disconnect
      AresMUSH.with_error_handling(nil, "Disconnecting client.") do
        @connection.close_connection true  # True flushes output first
      end
    end
    
    def handle_input(input)
      begin
        self.last_activity = Time.now
        return if input !~ /\S/
        self.input_buffer = self.input_buffer + input
        return if (!self.input_buffer.end_with?("\r") && !self.input_buffer.end_with?("\n"))
        input = self.input_buffer
        input.force_encoding(Encoding::UTF_8)
        input.scrub! if !input.valid_encoding?
        input.split("\n").each do |i|
          Global.dispatcher.queue_command(self, Command.new(i))
        end
        
        self.input_buffer = ""
      rescue Exception => e
         Global.logger.error("Error handling input: client=#{self} input=#{input} error=#{e} backtrace=#{e.backtrace[0,10]}")
      end
    end

    # Responds to a disconnect from any sort of source - socket error, client-initated, etc.
    def connection_closed
      Global.client_monitor.connection_closed self
    end

    def find_char
      @char_id ? Character[@char_id] : nil
    end
    
    def logged_in?
      @char_id
    end
    
    def reset_program
      @program = {}
    end


    # -------------------------------
    # Deprecated methods.  Do not use
    # -------------------------------
    def char
      raise "Someone still trying to use client.char"
    end  
    
    def name
      raise "Someone still trying to use client.name"
    end
    
    def room
      raise "Someone still trying to use client.room"
    end
    
  end
end