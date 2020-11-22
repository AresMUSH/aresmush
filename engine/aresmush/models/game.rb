module AresMUSH
  class Game < Ohm::Model
    include ObjectModel

    reference :system_character, "AresMUSH::Character"
    reference :master_admin, "AresMUSH::Character"
    
    # These are used when communicating with AresCentral
    attribute :api_game_id
    attribute :api_key
    
    attribute :player_api_keys, :type => DataType::Hash, :default => {}
    
    # There's only one game document and this is it!
    def self.master
      Game[1]
    end
    
    def is_special_char?(char)
      return true if char == system_character
      return true if char == master_admin
      return false
    end
    
    def self.web_portal_url
      host = Global.read_config('server', 'hostname')
      port = Global.read_config('server', 'web_portal_port')
      
      if (port.to_s == '80')
        port_str = ""
      else
        port_str = ":#{port}"
      end
      
      website = Global.read_config("game", "website") 
      
      if (website.blank?)
        return "http://#{host}#{port_str}"
      else
        return website
      end
    end    
  end
end
