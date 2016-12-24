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
        # This happens all the time when you close your browser tab or disconnect, so just ignore it.
      end
    end
    
    def send_formatted(msg)
      # Strip out < and > - may need to strip other things in the future
      send_data ClientFormatter.format(msg).gsub(/</, '&lt;').gsub(/>/, '&gt;')
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
        if (json_input["type"] == "input")
          @client.handle_input(json_input["message"] + "\r\n")
        elsif (json_input["type"] == "cmd")
          Global.logger.debug "Cmd input #{json_input}"
          Global.dispatcher.queue_event WebCmdEvent.new(client, json_input["cmd_name"], json_input["data"])
        else
          Global.logger.warn "Unexpected input from web client: #{data}"
        end
        
      rescue Exception => e
        Global.logger.warn "Error receiving data:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end

    private 

    def get_ip
      self.websocket.get_peername[2,6].unpack('nC4')[1..4].join('.')
    end    
  end
end