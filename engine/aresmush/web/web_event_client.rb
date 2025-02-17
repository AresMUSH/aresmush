module AresMUSH
  class WebEventClient
    attr_accessor :char_id, :stream
    
    def initialize(char_id, stream)
      @char_id = char_id
      @stream = stream
    end
    
    def character
      @char_id ? Character[@char_id] : nil
    end
    
    def web_notify(type, msg, is_data)
      char = self.character    
      data = {
        type: "notification",
        args: {
          notification_type: type,
          message: msg,
          character: char ? char.id : nil,
          timestamp: Time.now.rfc2822,
          is_data: is_data
        }
      }
    
      self.send_data(data)
    end
    
    def ping()
      self.send_data("\0")
    end
    
    def send_data(data)
      Global.logger.debug "Sending data #{data}"
      
      @stream << "data: #{data.to_json}\n\n"
    end
  end
end

