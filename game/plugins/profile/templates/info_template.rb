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
        !dob ? "" : ICTime::Api.ic_datestr(dob)
      end

      def faction
        @char.group_value("Faction")
      end

      def position
        @char.group_value("Position")
      end

      def colony
        @char.group_value("Colony")
      end

      def department
        @char.group_value("Department")
      end

      def rank
        @char.rank
      end
    end
  end
end