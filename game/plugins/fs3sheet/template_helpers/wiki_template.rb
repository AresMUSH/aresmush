module AresMUSH
  module Sheet
    class WikiTemplate
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
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