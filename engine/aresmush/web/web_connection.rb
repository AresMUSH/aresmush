module AresMUSH

  # @engineinternal true
  class WebConnection
    attr_accessor :websocket, :ip_addr, :ready_callback, :connected_at
    attr_reader :client, :char_id
    
    def initialize(websocket, &ready_callback)
      self.websocket = websocket
      self.ready_callback = ready_callback
      self.connected_at = Time.now
      websocket.onopen { |handshake| connection_opened(handshake) }
      websocket.onclose { connection_closed }
      websocket.onmessage { |msg| receive_data(msg) }
    end

    def ping
      data = {
        type: "notification",
        args: {
          notification_type: "ping",
          message: Time.now.rfc2822,
          character: @char_id
        }
      }
      send_data data.to_json.to_s
    end
        
    def connection_opened(handshake)
      begin
        @ip_addr = get_ip
        
        # Deny banned sites and send back nil to indicate a rejected connection
        if (Game.master.is_banned_site?(@ip_addr, ""))
          self.close_connection
          ready_callback.call(nil)
        else
          ready_callback.call(self)
        end
                                                    
        
      rescue Exception => e
        Global.logger.warn "Error opening connection:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end
    
    def is_web_connection?
      true
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
    
    def send_web_notification(type, message, is_data)
      char = @char_id ? Character[@char_id] : nil
      data = {
        type: "notification",
        args: {
          notification_type: type,
          message: message,
          character: @char_id,
          timestamp: Time.now.rfc2822,
          is_data: is_data
        }
      }
      send_data data.to_json.to_s
    end
    
    def send_formatted(msg, color_mode = "FANSI", ascii_mode = false, screen_reader = false)
       raise "Tried to send formatted text to web client."
    end
    
    def send_raw(msg)      
      raise "Tried to send raw text to web client."     
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
      return if !@client
      
      begin
        json_input = JSON.parse(data)
        
        @client.last_activity = Time.now
        
        if (json_input["type"] == "input")
          @client.handle_input(json_input["message"] + "\r\n")        
        elsif (json_input["type"] == "identify")
          data = json_input["data"]
          @char_id = data ? data["id"] : nil
          if (@client)
            @client.char_id = @char_id
          end
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