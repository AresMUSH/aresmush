module AresMUSH

  class WebConnection
    attr_accessor :client, :websocket, :ip_addr, :ready_callback
    
    def initialize(websocket, &ready_callback)
      self.websocket = websocket
      self.ready_callback = ready_callback
      websocket.onopen { |handshake| connection_opened(handshake) }
      websocket.onclose { close_connection }
      websocket.onmessage { |msg| receive_data(msg) }
    end

    def ping
      # No-Op for web clients.
    end
    
    def connection_opened(handshake)
      begin
        @ip_addr = get_ip
        ready_callback.call(self)
      rescue Exception => e
        Global.logger.warn "Error opening connection:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end
    
    def send_data(msg)
      begin
        self.websocket.send msg
      rescue Exception => e
        Global.logger.warn "Could not send to web connection:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end
    
    def send_formatted(msg)
      send_data ClientFormatter.format(msg)
    end
    
    def close_connection(dummy = nil)  # Dummy for compatibility with the other connection class.
      begin
        @client.connection_closed        
        self.websocket.close
      rescue Exception => e
        Global.logger.warn "Couldn't close connection:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end
    
    def receive_data(data)
      begin
        json_input = JSON.parse(data)
        data_type = json_input["type"]
        if (data_type == "input")
          @client.handle_input(json_input["message"] + "\r\n")
        elsif (data_type == "command")
          help_info = Global.config_reader.get_config("help")["categories"].keys
          cmd = { "status" => "OK", "cmd" => json_input["cmd"], "data" => help_info, "error" => nil }
          @client.emit cmd
        elsif (data_type == "response")
          cmd = { "status" => "OK", "cmd" => json_input["cmd"], "error" => nil }
          @client.emit cmd
        else
          Global.logger.debug "Unexpected web input: #{data}"
        end
        
      rescue Exception => e
        Global.logger.warn "Error receiving data:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end

    private 
    
    # TODO
    #def strip_control_chars(data)
    #  stripped = data.gsub(/\^M/,"\n")
    #  stripped = stripped.gsub(/\0/,"")
    #  stripped.gsub(/\^@/,"")
    #end   

    def get_ip
      self.websocket.get_peername[2,6].unpack('nC4')[1..4].join('.')
    end    
  end
end