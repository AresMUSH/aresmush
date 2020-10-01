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
      @hostname = Client.lookup_hostname(@ip_addr)
      @program = {}
    end
    
    def to_s
      "ID=#{id}"
    end
    
    def connected
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
    
    def screen_reader
      return false if !@char_id
      self.char.screen_reader
    end
    
    def display_settings
      if (@char_id)
        return ClientDisplaySettings.from_char(self.char)
      else
        return ClientDisplaySettings.from_char(nil)
      end
    end
    
    def beep
      @connection.beep
    end
  
    def emit(msg)
      @connection.send_formatted "#{msg}", self.display_settings
    end 
    
    def emit_ooc(msg)
      prefix = screen_reader ? "#{t('global.system')}:" : "%%" 
      @connection.send_formatted "%xc#{prefix} #{msg}%xn", self.display_settings
    end

    def emit_success(msg)
      prefix = screen_reader ? "#{t('global.system')}:" : "%%" 
      @connection.send_formatted "%xg#{prefix} #{msg}%xn", self.display_settings
    end

    def emit_failure(msg)
      prefix = screen_reader ? "#{t('global.system')}:" : "%%" 
      @connection.send_formatted "%xr#{prefix} #{msg}%xn", self.display_settings
    end
    
    def emit_raw(msg)
      @connection.send_raw "#{msg}\r\n"
    end
    
    def web_notify(type, message, is_data)
      @connection.web_notify type, message, is_data
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
    
    def find_char
      @char_id ? Character[@char_id] : nil
    end
    
    def logged_in?
      @char_id
    end
    
    def reset_program
      @program = {}
    end
    
    
    # @engineinternal true
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
    # @engineinternal true
    def connection_closed
      Global.client_monitor.connection_closed self
    end

    # Do not cache the character object!  It will get stale and out of date.
    # @engineinternal true
    def char
      find_char
    end
    
    # @engineinternal true
    def web_char_id
      @connection.web_char_id
    end
    
    def self.lookup_hostname(ip)
      begin
        return Resolv.getname ip
      rescue
        return ""
      end
    end
    
  end
end