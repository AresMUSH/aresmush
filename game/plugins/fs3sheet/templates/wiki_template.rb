module AresMUSH
  module FS3Sheet
    class WikiTemplate
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
      end
      
      def display
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
        text << "|callsign=[!-- Callsign --]%r"
        text << "|height=#{ height }%r"
        text << "|physique=#{ physique }%r"
        text << "|eyes=#{ eyes }%r"
        text << "|hair=#{ hair }%r"
        text << "]]"
        
        text
      end
      
      def name
        @char.name
      end
      
      def fullname
        @char.fullname
      end
      
      def gender
        @char.gender
      end
      
      def height
        @char.height
      end
      
      def physique
        @char.physique
      end
      
      def hair
        @char.hair
      end
      
      def eyes
        @char.eyes
      end
      
      def age
        age = @char.age
        age == 0 ? "" : age
      end
      
      def actor
        @char.actor
      end
      
      def birthdate
        @char.birthdate.nil? ? "" : ICTime.ic_datestr(@char.birthdate)
      end
      
      def faction
        @char.groups['Faction']
      end
      
      def position
        @char.groups['Position']
      end
      
      def colony
        @char.groups['Colony']
      end
      
      def department
        @char.groups['Department']
      end

      def rank
        @char.rank
      end
            
      def reputation
        @char.reputation
      end
    end
  end
end