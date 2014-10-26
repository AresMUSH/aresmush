module AresMUSH
  module Handles
    def self.handle_name_valid?(name)
      return false if name.blank?
      name.start_with?("@")
    end
    
    def self.build_profile_text(profile_char, asking_char)
      if (Global.api_router.is_master?)
        list = []
        list << t('handles.profile_title')
        list << "%l2"
        profile_char.linked_characters.values.each do |c| 
          next if c['privacy'] == Handles.privacy_admin
          next if c['privacy'] == Handles.privacy_friends && !profile_char.friends.includ?(asking_char)
          
          game = ServerInfo.find_by_dest_id(c['game_id'])
          game_name = game.nil? ? "Unknown" : game.name
          name = "#{c['name']}@#{game_name}"
          last_online = "#{c['last_online']}"   
          list << "#{name.ljust(40)} #{last_online}"
        end
        
        BorderedDisplay.list list, t('handles.profile_for_title', :name => profile_char.name)
      else
        return t('api.use_command_on_central')
      end
    end
  end
end