module AresMUSH
  module Status
    
      def self.status_color(status)
        status = status.upcase
        config = Global.read_config("status", "colors")
        return config[status] if config.has_key?(status)
        return ""
      end
    
      def self.is_idle?(client)
        minutes_before_idle = "#{Global.read_config("status", "minutes_before_idle")}".to_i
        return false if !minutes_before_idle
        return client.idle_secs > minutes_before_idle * 60
      end
      
      def self.update_last_ic_location(char)
        if (char.room.room_type == "IC")
          char.update(last_ic_location: char.room)
        end
      end
      
      def self.activity_status(char)
        client = Login.find_game_client(char)
        if (client)
          return 'game-inactive' if char.is_afk?
          return Status.is_idle?(client) ? 'game-inactive' : 'game-active'
        end
        client = Login.find_web_client(char)
        if (!client)
          return 'offline'
        end
      
        return Status.is_idle?(client) ? 'web-inactive' : 'web-active'
      end
      
      def self.is_active?(char)
        status = Status.activity_status(char)
        status == 'web-active' || status == 'game-active'
      end
      
      def self.build_web_profile_edit_data(char, viewer, is_profile_manager)
        {
          show_status_tab: Status.can_manage_status?(viewer),
          is_npc: char.is_npc,
          is_playerbit: char.is_playerbit            
        }
      end
      
      def self.save_web_profile_data(char, enactor, args)
        if Status.can_manage_status?(enactor)
          char.update(is_npc: (args["is_npc"] || "").to_bool)
        end
        
        char.update(is_playerbit: (args["is_playerbit"] || "").to_bool)
        return nil
      end
      
  end  
end