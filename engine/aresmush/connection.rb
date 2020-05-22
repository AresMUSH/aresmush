module AresMUSH

  # @engineinternal true
  class Connection < EventMachine::Connection
    attr_accessor :window_width, :window_height
    attr_reader :ip_addr, :client
    
    # For unit testing only
    attr_accessor :negotiator
    
    def post_init
      begin
        port, @ip_addr = Socket.unpack_sockaddr_in(get_peername)
        @window_width = 78
        @window_height = 24
        @input_buf = ""
        @negotiator = TelnetNegotiation.new(self)

        @negotiator.send_naws_request
        @negotiator.send_charset_request
                
          
      rescue Exception => e
        Global.logger.warn "Could not decode IP address.  error=#{e} backtrace=#{e.backtrace[0,10]}"
        @ip_addr = "0.0.0.0"
      end
    end

    def ping
      send_data ANSI.reset
    end
    
    def beep
      send_data "\a\r\n"
    end
    
    def connect_client(client)
      Global.logger.info("Client connected from #{@ip_addr}. ID=#{client.id}.")
      @client = client
    end
    
    
    def send_data(msg)
      begin
        #telnet_debug(msg, "SEND")
        super msg
      rescue Exception => e
        Global.logger.warn "Could not send to connection:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end
    
    def send_formatted(msg, display_settings = ClientDisplaySettings.new)
      send_data MushFormatter.format(msg, display_settings)
    end
    
    def send_raw(msg)
      send_data msg
    end
    
    def close_connection(after_writing = false)
      begin
        Global.logger.info("Client #{self.client.id} disconnected.")
        super
      rescue Exception => e
        Global.logger.warn "Couldn't close connection:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end
    
    def receive_data(data)
      begin
        return if !data
                
        if (!@input_buf.blank?)
          data = "#{@input_buf}#{data}"
          @input_buf = ""
        end
           
        data_terminated = data.end_with?("\n") || data.end_with?("\r")
         
        if (!data_terminated)
          if (!@input_buf)
            @input_buf = ""
          end
          @input_buf << data
          
          if (@negotiator.is_control?(@input_buf))
            #telnet_debug(@input_buf, "RECV")
            @input_buf = @negotiator.handle_input(@input_buf)
          end
         
          return
        end
         
        
        if (data =~ /.+\r|\n.+/)
          parts = data.split(/\r|\n/).map { |p| "#{p}\n"}
        else
          parts = [ data ]
        end
        
        parts.each do |part|
          #telnet_debug(part, "RECV")
          
          next if !part  # Ignore nil part
          
          # Ignore if only whitespace.
          if (part !~ /\S/)
            next
          end
          
          part = "#{part.chomp}\n"
          input = @negotiator.handle_input(part)
          if (!input)
            return
          end

          input = strip_control_chars(input)          
          @client.handle_input(input)
        end
      rescue Exception => e
        Global.logger.warn "Error receiving data:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end

    def unbind
      begin
        @client.connection_closed
      rescue Exception => e
        Global.logger.warn "Error closing connection:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end  
    
    def web_notify(type, message, is_data)
      # Nothing - not a web connection
    end
    
    def web_char_id
      # Nothing - not a web connection
    end
    
    private 
    
    def strip_control_chars(data)
      stripped = data.gsub(/\^M/,"\n")
      stripped = stripped.gsub(/\0/,"")
      stripped.gsub(/\^@/,"")
    end   
    
    def telnet_debug(part, prefix)
      chars = part.split("").map { |c| c.ord }
      
      special = {
        255 => "IOC",
        253 => "DO",
        254 => "DON'T",
        251 => "WILL",
        252 => "WON'T",
        241 => "NOP",
        250 => "SUBNEG",
        240 => "ENDSUB",
        1 => "REQ",
        42 => "CHARSET",
        31 => "NAWS",
        24 => "TTYPE",
        '\r'.ord => "CR",
        '\n'.ord => "LF",
        20 => "_"
      }


      output = []
      chars.each do |c|
        val = c.to_i

        if (special[val])
          txt = special[val]
        else
          txt = val.chr
        end

        if (val == 0 || val == 255)
          output << "\n"
        end

        output << "#{c} (#{txt})"

      end

      puts "#{prefix} ---------------"
      puts "#{part.inspect.strip}#{output.join(" ")}"
      
    end
  end
end