module AresMUSH
  class Character
    def age
      Demographics.calculate_age(demographic(:birthdate))
    end
    
    def demographic(name)
      return nil if !self.demographics
      self.demographics.send(name)
    end  
  end
  
  module Demographics
    module Api
      def self.app_review(char)
        Demographics.app_review(char)
      end
      
      # His/Her/Their
      def self.possessive_pronoun(char)
        t("demographics.#{char.demographic(:gender).downcase}_possessive")
      end

      # He/She/They
      def self.subjective_pronoun(char)
        t("demographics.#{char.demographic(:gender).downcase}_subjective")
      end

      # Him/Her/Them
      def self.objective_pronoun(char)
        t("demographics.#{char.demographic(:gender).downcase}_objective")
      end
    end
  end
  
end