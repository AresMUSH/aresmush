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
        Demographics::Interface.fullname(@char)
      end
      
      def gender
        Demographics::Interface.gender(@char)
      end
      
      def height
        Demographics::Interface.demographic(@char, :height)
      end
      
      def physique
        Demographics::Interface.demographic(@char, :physique)
      end
      
      def hair
        Demographics::Interface.demographic(@char, :hair)
      end
      
      def eyes
        Demographics::Interface.demographic(@char, :eyes)
      end
      
      def age
        age = Demographics::Interface.age(@char)
        age == 0 ? "" : age
      end
      
      def actor
        Actors::Interface.actor(@char)
      end
      
      def birthdate
        dob = Demographics::Interface.demographic(@char, :birthdate)
        dob.nil? ? "" : ICTime::Interface.ic_datestr(dob)
      end
      
      def callsign
        Demographics::Interface.demographic(@char, :callsign)
      end
      
      
      def faction
        Groups::Interface.group(@char, "Faction")
      end
      
      def position
        Groups::Interface.group(@char, "Position")
      end
      
      def colony
        Groups::Interface.group(@char, "Colony")
      end
      
      def department
        Groups::Interface.group(@char, "Department")
      end

      def rank
        Ranks::Interface.rank(@char)
      end
            
      def background
        "+ Background%R#{ Chargen::Interface.background(@char) } "
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