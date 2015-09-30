module AresMUSH
  module Handles    
    class HandleProfileTemplate
      include TemplateFormatters

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
        text = center( "%xh#{t('handles.profile_char_list_title')}%xn", 78)
        
        games = {}
        
        @profile_char.linked_characters.values.each do |c| 
          next if c['privacy'] == Handles.privacy_admin
          next if c['privacy'] == Handles.privacy_friends && !@asking_char
          next if c['privacy'] == Handles.privacy_friends && !@profile_char.friends.include?(@asking_char)
        
          game = ServerInfo.find_by_dest_id(c['game_id'])
          game_name = game.nil? ? "Unknown" : game.name

          if (games.has_key?(game_name))
            games[game_name] << c
          else
            games[game_name] = [c]
          end
        end

        games.each do |game, chars|
          text << "%R%xh#{game}%xn%R%T"
          text << chars.map { |c| c["name"] }.sort.join(", ")
        end
        text << "%R%R"
        text << t('handles.alts_notice')
        text
      end
    end
  end
end