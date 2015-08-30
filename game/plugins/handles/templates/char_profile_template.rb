module AresMUSH
  module Handles
    class CharProfileTemplate
      include TemplateFormatters
      
      def initialize(client, char)
        @client = client
        @char = char
      end
      
      def display
          text = "-~- %xh%xg#{@char.name}@#{Global.read_config("game", "name")}%xn -~-".center(78)
          text << "%r"
          text << status
          text << last_on
          text << location
          text << timezone
          text << played_by
          text << alts
          text << custom_profile
                    
          BorderedDisplay.text text
      end
      
      def format_field_title(title)
        "%R%xh#{left(title, 12)}%xn"
      end
      
      def status
        text = format_field_title t('handles.status')
        text << Chargen.approval_status(@char)
        text
      end
      
      def alts
        text = format_field_title t('handles.alts')
        text << Handles.get_visible_alts(@char, @client.char)
        text << "%R%R#{t('handles.alts_notice')}"
        text
      end
      
      def played_by
        text = format_field_title t('handles.played_by')
        text << @char.actor
        text
      end
      
      def last_on
        text = format_field_title t('handles.last_on')
        if (@char.client)
          text << t('handles.currently_connected')
        else
          text << OOCTime.local_long_timestr(@client, @char.last_on)
        end
        text
      end
      
      def timezone
        text = format_field_title t('handles.timezone')
        text << @char.timezone
        text
      end
      
      def location
        text = format_field_title t('handles.location')
        text << Who.who_room_name(@char)
        text
      end
      
      def custom_profile
        return "" if @char.profile.empty?
        Handles.format_custom_profile(@char)
      end
    end
  end
end