module AresMUSH
  module Profile
    class InfoTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char, client)
        @char = char
        super File.dirname(__FILE__) + "/info.erb"
      end
      
      def actor
        @char.actor
      end
      
      def approval_status
        Chargen::Api.approval_status(@char)
      end
      
      def fullname
        Demographics::Api.demographic(@char, :fullname)
      end

      def callsign
        Demographics::Api.demographic(@char, :callsign)
      end

      def gender
        Demographics::Api.demographic(@char, :gender)
      end

      def height
        Demographics::Api.demographic(@char, :height)
      end

      def physique
        Demographics::Api.demographic(@char, :physique)
      end

      def hair
        Demographics::Api.demographic(@char, :hair)
      end

      def eyes
        Demographics::Api.demographic(@char, :eyes)
      end

      def skin
        Demographics::Api.demographic(@char, :skin)
      end

      def age
        age = Demographics::Api.age(@char)
        age == 0 ? "" : age
      end

      def birthdate
        dob = Demographics::Api.demographic(@char, :birthdate)
        !dob ? "" : ICTime::Api.ic_datestr(dob)
      end

      def faction
        Groups::Api.group(@char, "Faction")
      end

      def position
        Groups::Api.group(@char, "Position")
      end

      def colony
        Groups::Api.group(@char, "Colony")
      end

      def department
        Groups::Api.group(@char, "Department")
      end

      def rank
        Ranks::Api.rank(@char)
      end
    end
  end
end