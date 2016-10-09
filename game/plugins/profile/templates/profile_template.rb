module AresMUSH
  module Profile
    class ProfileTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(enactor, char)
        @char = char
        @enactor = enactor
        super File.dirname(__FILE__) + "/profile.erb"
      end

      def status
        Chargen::Api.approval_status(@char)
      end
      
      def alts
        alt_list = Handles::Api.alts(@char).map { |c| c.name }
        alt_list.delete(@char.name)
        alt_list.join(" ")
      end
      
      def played_by
        @char.actor
      end
      
      def last_on
        if (@char.client)
          t('profile.currently_connected')
        else
          OOCTime::Api.local_long_timestr(@enactor, @char.last_on)
        end
      end
      
      def timezone
        @char.timezone
      end
      
      def custom_profile
        !@char.profile_fields.empty?
      end
      
      def handle_name
        @char.handle.name
      end
      
      def handle_profile
        arescentral = Global.read_config("arescentral", "arescentral_url")
        "#{arescentral}/handle/#{@char.handle.name}"
      end
    end
  end
end