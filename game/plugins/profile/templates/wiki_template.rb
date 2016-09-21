module AresMUSH
  module Profile
    class WikiTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char, client)
        @char = char
        super client
      end
      
      def build
        text = "[[include characterbox%r"
        text << "|image=%r"
        text << "|actor=#{ actor }%r"
        text << "|fullname=#{ fullname }%r"
        text << "|age=#{ age }%r"
        text << "|alias=[!-- Aliases or nicknames --]%r"
        text << "|colony=#{ colony }%r"
        text << "|department=#{ department }%r"
        text << "|position=#{ position }%r"
        text << "|rank=#{ rank }%r"
        text << "|callsign=#{ callsign }%r"
        text << "|height=#{ height }%r"
        text << "|physique=#{ physique }%r"
        text << "|eyes=#{ eyes }%r"
        text << "|hair=#{ hair }%r"
        text << "]]"
        text << "%R%R"
        text << background
        text << "%R%R"
        text << hooks
        text << "%R%R"
        text << goals        
        text << "%R%R"
        text << "+ IC Events%R"
        text << "[[include LogList name=#{name}]]"
        text << "%R%R"
        text << "+ Relationships%R"
        text << "[[include RelationshipsTop]]"
        text << "%R%R"
        text << "[[include RelationshipBox%R"
        text << "| name=<mush name here>%R"
        text << "| relationship=**<Relation>** - <describe relationship>%R"
        text << "]]"
        text << "%R%R"
        text << "[[include RelationshipBoxNoImage%R"
        text << "| name=<Name>%R"
        text << "| relationship=**<Relation>** - <describe relationship>%R"
        text << "]]%R"
        text << "[[include RelationshipsBottom]]"
        text << "%R%R"
        text << "+ Gallery%R"
        text << "[[gallery]]"
        text
      end
      
      def name
        @char.name
      end
      
      def fullname
        Demographics::Api.fullname(@char)
      end
      
      def gender
        Demographics::Api.gender(@char)
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
        Actors::Api.get_actor(@char)
      end
      
      def birthdate
        dob = Demographics::Api.demographic(@char, :birthdate)
        dob.nil? ? "" : ICTime::Api.ic_datestr(dob)
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
        "+ Background%R#{ Chargen::Api.background(@char) } "
      end

      def hooks
        text = "+ RP Hooks"
        text << "%R"
        text << @char.hooks.map { |h, v| "%R* **#{h}** - #{v}" }.join
        text
      end

      def goals
        text = "+ Goals"
        text << "%R"
        text << @char.goals.map { |h, v| "%R* **#{h}** - #{v}" }.join
        text
      end

      def interests
        text = "+ Interests"
        text << "%R"
        text << @char.fs3_interests.map { |v| "%R* **#{v}**" }.join
        text
      end

      def expertise
        text = "+ Expertise"
        text << "%R"
        text << @char.fs3_expertise.map { |v| "%R* **#{v}**" }.join
        text
      end

    end
  end
end