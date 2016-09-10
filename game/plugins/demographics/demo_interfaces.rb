module AresMUSH
  module Demographics
    module Interface
      def self.app_review(char)
        Demographics.app_review(char)
      end
      
      def self.age(char)
        char.age
      end
      
      def self.fullname(char)
        char.fullname
      end
      
      def self.gender(char)
        char.gender
      end
      
      def self.demographic(char, name)
        char.demographic(name)
      end
      
      # His/Her/Their
      def self.possessive_pronoun(char)
        t("demographics.#{char.gender.downcase}_possessive")
      end

      # He/She/They
      def self.subjective_pronoun(char)
        t("demographics.#{char.gender.downcase}_subjective")
      end

      # Him/Her/Them
      def self.objective_pronoun(char)
        t("demographics.#{char.gender.downcase}_objective")
      end
    end
  end
  
end