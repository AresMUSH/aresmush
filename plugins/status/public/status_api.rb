module AresMUSH
  module Status
    
      def self.status_color(status)
        status = status.upcase
        config = Global.read_config("status", "colors")
        return config[status] if config.has_key?(status)
        return ""
      end
    
      def self.is_idle?(client)
        Status.calculate_is_idle(client.idle_secs)
      end
      
      def self.update_last_ic_location(char)
        if (char.room.room_type == "IC")
          char.update(last_ic_location: char.room)
        end
      end
      
      def self.activity_status(char)
        client = Login.find_client(char)
        if (client)
          return 'game-inactive' if char.is_afk?
          return Status.is_idle?(client) ? 'game-inactive' : 'game-active'
        end
        client = Login.find_web_client(char)
        if (!client)
          return 'offline'
        end
      
        idle_secs = Time.now - char.last_on
        is_idle = Status.calculate_is_idle(idle_secs)
        
        return is_idle ? 'web-inactive' : 'web-active'
      end
      
      def self.is_active?(char)
        status = Status.activity_status(char)
        status == 'web-active' || status == 'game-active'
      end
      
  end  
end