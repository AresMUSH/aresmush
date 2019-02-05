module AresMUSH

  class WebConnection
    attr_accessor :websocket, :ip_addr, :ready_callback
    attr_reader :client, :web_char_id, :webclient
    
    def initialize(websocket, &ready_callback)
      self.websocket = websocket
      self.ready_callback = ready_callback
      websocket.onopen { |handshake| connection_opened(handshake) }
      websocket.onclose { connection_closed }
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
    
    def connect_client(client)
      @client = client
    end
    
    def send_data(msg)
      begin
        self.websocket.send msg
      rescue Exception => e
        # This happens all the time when you close your browser tab or disconnect, so just ignore it.
      end
    end
    
    def web_notify(type, message)   
      char = @web_char_id ? Character[@web_char_id] : nil
      data = {
        type: "notification",
        args: {
          notification_type: type,
          message: message,
          character: @web_char_id,
          timestamp: OOCTime.local_long_timestr(nil, Time.now)
        }
      }
      send_data data.to_json.to_s
    end
    
    def send_formatted(msg, enable_fansi = false, ascii_mode = false)
       # Strip out < and > - may need to strip other things in the future
      formatted = MushFormatter.format(msg, false).gsub(/</, '&lt;').gsub(/>/, '&gt;')
      
      data = {
        type: "notification",
        args: {
          notification_type: "webclient_output",
          message: formatted,
          character: @web_char_id
        }
      }
      
      send_data data.to_json.to_s
    end
    
    # Just announces that the websocket was closed.
    def connection_closed
      if (@client)
        @client.connection_closed        
      end
    end
    
    def close_connection(dummy = nil)  # Dummy for compatibility with the other connection class.
      begin
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
        elsif (json_input["type"] == "identify")
          data = json_input["data"]
          @web_char_id = data ? data["id"] : nil
          @webclient = data["webclient"]
        elsif (json_input["type"] == "cmd")
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