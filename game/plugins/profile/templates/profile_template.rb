module AresMUSH
  module Profile
    class ProfileTemplate < ErbTemplateRenderer
      
      attr_accessor :char
      
      def initialize(enactor, char)
        @char = char
        @enactor = enactor
        super File.dirname(__FILE__) + "/profile.erb"
      end

      def approval_status
        Chargen.approval_status(@char)
      end
      
      def fullname
        @char.demographic(:fullname)
      end

      def callsign
        @char.demographic(:callsign)
      end

      def gender
        @char.demographic(:gender)
      end

      def height
        @char.demographic(:height)
      end

      def physique
        @char.demographic(:physique)
      end

      def hair
        @char.demographic(:hair)
      end

      def eyes
        @char.demographic(:eyes)
      end

      def skin
        @char.demographic(:skin)
      end

      def age
        age = @char.age
        age == 0 ? "" : age
      end

      def birthdate
        dob = @char.demographic(:birthdate)
        !dob ? "" : ICTime.ic_datestr(dob)
      end

      def faction
        @char.group("Faction")
      end

      def position
        @char.group("Position")
      end

      def colony
        @char.group("Colony")
      end

      def department
        @char.group("Department")
      end

      def rank
        @char.rank
      end
      
      def desc
        @char.description
      end
      
      def status
        Chargen.approval_status(@char)
      end
      
      def alts
        alt_list = AresCentral.alts(@char).map { |c| c.name }
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
          OOCTime.local_long_timestr(@enactor, @char.last_on)
        end
      end
      
      def timezone
        @char.timezone
      end
      
      def custom_profile
        !@char.profile.empty?
      end
      
      def handle_name
        @char.handle.name
      end
      
      def unread_mail
        t('profile.unread_message_count', :num => @char.num_unread_mail)
      end
      
      def wiki
        game_site = Game.web_portal_url
        "#{game_site}/char:#{@char.name}"
      end
      
      def handle_profile
        arescentral = Global.read_config("arescentral", "arescentral_url")
        "#{arescentral}/handle/#{@char.handle.name}"
      end
    end
  end
end