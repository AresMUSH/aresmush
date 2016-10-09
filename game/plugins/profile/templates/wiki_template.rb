module AresMUSH
  module Profile
    class WikiTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/wiki.erb"
      end
      
      def fullname
        Demographics::Api.demographic(@char, :fullname)
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
      
      def age
        age = Demographics::Api.age(@char)
        age == 0 ? "" : age
      end
      
      def actor
        @char.actor
      end
      
      def birthdate
        dob = Demographics::Api.demographic(@char, :birthdate)
        !dob ? "" : ICTime::Api.ic_datestr(dob)
      end
      
      def callsign
        Demographics::Api.demographic(@char, :callsign)
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
            
      def background
        Chargen::Api.background(@char)
      end

      def hooks
        #@char.hooks.map { |h, v| "%R* **#{h}** - #{v}" }.join
        "" # TODO
      end
    end
  end
end