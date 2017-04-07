module AresMUSH
  class Character
    def age
      Demographics.calculate_age(demographic(:birthdate))
    end
    
    def actor
      demographic(:actor) || t('demographics.actor_not_set')
    end
    
    def demographic(key)
      name = key.to_s
      return self.birthdate if name == "birthdate"
      return self.demographics[name]
    end
    
    def update_demographic(key, value)
      name = key.to_s
      if (name == "birthdate")
        self.update(birthdate: value)
      else
        demo = self.demographics
        demo[name] = value
        self.update(demographics: demo)
      end
    end
  end
  
  module Demographics
    module Api
      def self.app_review(char)
        Demographics.app_review(char)
      end
      
      def self.gender(char)
        g = char.demographic(:gender) || "Other"
        g.downcase
      end
      
      # His/Her/Their
      def self.possessive_pronoun(char)
        t("demographics.#{gender(char)}_possessive")
      end

      # He/She/They
      def self.subjective_pronoun(char)
        t("demographics.#{gender(char)}_subjective")
      end

      # Him/Her/Them
      def self.objective_pronoun(char)
        t("demographics.#{gender(char)}_objective")
      end
      
      # Man/Woman/Person
      def self.gender_noun(char)
        t("demographics.#{gender(char)}_noun")
      end
    end
  end
  
end