module AresMUSH
  module Handles
    class HandleProfileTemplate
      def initialize(profile_char, asking_char)
        @profile_char = profile_char
        @asking_char = asking_char
      end
      
      def display
          text = "-~- %xh%xg@#{@profile_char.name}%xn -~-".center(78)
          text << custom_profile
          text << "%r%l2%r"
          text << character_list
          
          BorderedDisplay.text text
      end
      
      def custom_profile
        return "" if @profile_char.profile.empty?
        Handles.format_custom_profile(@profile_char)
      end
      
      def character_list
        text = t('handles.profile_char_list_title')
        text << "%r%l2"
        @profile_char.linked_characters.values.each do |c| 
          next if c['privacy'] == Handles.privacy_admin
          next if c['privacy'] == Handles.privacy_friends && !@asking_char
          next if c['privacy'] == Handles.privacy_friends && !@profile_char.friends.include?(@asking_char)
        
          game = ServerInfo.find_by_dest_id(c['game_id'])
          game_name = game.nil? ? "Unknown" : game.name
          name = "#{c['name']}@#{game_name}"
          last_online = "#{c['last_login']}"   
          text << "%R#{name.ljust(40)} #{last_online}"
        end
        text << "%R%R"
        text << t('handles.alts_notice')
        text
      end
    end
  end
end