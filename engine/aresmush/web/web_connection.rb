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
      websocket.onmessage { |msg| receive_message(msg) }
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
    
    def connection_closed
      # Announces that the websocket was closed.
      if (@client)
        @client.connection_closed        
      end
      @char_id = nil
    end
    
    def close_connection(dummy = nil)  # Dummy for compatibility with the other connection class.
      begin
        self.websocket.close
      rescue Exception => e
        Global.logger.warn "Couldn't close connection:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end
    

    private
    
    def receive_message(message)
      return if !@client
      
      begin
        json_message = JSON.parse(message)
        api_key = json_message["api_key"]
        auth = json_message["auth"]
        enactor = nil
        
        if (!Website.check_api_key(api_key))
          Global.logger.warn "Unexpected websocket client from IP #{self.get_ip}"
          self.close_connection
          return;
        end
        
        if (auth['id'])
          enactor = self.check_token(auth['id'], auth['token'])
          if (!enactor)            
            self.close_connection
            return
          end
        end
        
        @client.last_activity = Time.now
        
        if (json_message["type"] == "identify")
          handle_identify(json_message, enactor)
        else
          Global.logger.warn "Unexpected input from websocket: #{data}"
        end
        
      rescue Exception => e
        Global.logger.warn "Error receiving data:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end
    
    def handle_identify(json_message, enactor)
      data = json_message["data"]
      id = data ? data["id"] : nil
      
      # Double checking in case of race condition
      if (@client)
        if (id)
          id_char = Character[id]
        
          if (!enactor || !id_char || !Character.is_alt?(id_char, enactor))
            Global.logger.warn "Websocket invalid character ID #{id} #{enactor ? enactor.id : 'None'}"
            self.close_connection
            return              
          end
          @char_id = id
        end
        Global.logger.debug "Websocket char ID updated #{@char_id || 'None'}"
        @client.char_id = @char_id
      else
        @char_id = nil
      end
    end
    
    def check_token(char_id, token)
      Global.logger.debug "Websocket checking token #{char_id}"
      char = Character[char_id]
      if (!char || !char.is_valid_api_token?(token))
        Global.logger.warn "Websocket session invalid #{char_id}."
        return nil
      end
      return char
    end  
    
    def get_ip
      begin
        return self.websocket.get_peername[2,6].unpack('nC4')[1..4].join('.')
      rescue
        return ""
      end
    end
  end
end