module AresMUSH
  module Profile
    class CharProfileTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      def initialize(client, char)
        @char = char
        super client
      end
      
      def build
          text = "-~- %xh%xg#{@char.name}@#{Global.read_config("game", "name")}%xn -~-".center(78)
          text << "%r"
          text << status
          text << last_on
          text << timezone
          text << played_by
          text << alts
          text << custom_profile
          text << handle_profile
                    
          BorderedDisplay.text text
      end
      
      def format_field_title(title)
        "%R%xh#{left(title, 12)}%xn"
      end
      
      def status
        text = format_field_title t('profile.status')
        text << Chargen::Interface.approval_status(@char)
        text
      end
      
      def alts
        text = format_field_title t('profile.alts')
        alt_list = Handles::Interface.alts(@char).map { |c| c.name }
        alt_list.delete(@char.name)
        text << alt_list.join(" ")
        text
      end
      
      def played_by
        text = format_field_title t('profile.played_by')
        text << Actors::Interface.actor(@char)
        text
      end
      
      def last_on
        text = format_field_title t('profile.last_on')
        if (@char.client)
          text << t('profile.currently_connected')
        else
          text << OOCTime::Interface.local_long_timestr(self.client, Manage::Interface.last_on(@char))
        end
        text
      end
      
      def timezone
        text = format_field_title t('profile.timezone')
        text << OOCTime::Interface.timezone(@char)
        text
      end
      
      def custom_profile
        return "" if @char.profile.empty?
        Profile.format_custom_profile(@char)
      end
      
      def handle_profile
        if (@char.handle)
          arescentral = Global.read_config("api", "arescentral_url")
          url = "#{arescentral}/handle/#{@char.handle_id}"
          text = "%r%l2"
          text << format_field_title(t('profile.handle'))
          text << @char.handle
          text << format_field_title(t('profile.handle_profile'))
          text << url
        else
          ""
        end
      end
    end
  end
end