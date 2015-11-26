module AresMUSH
  module FS3Skills

    # Expects titleized ability name and return ability rating.
    def self.ability_rating(char, ability)
      ability_type = FS3Skills.get_ability_type(char, ability)
      case ability_type
        when :expertise
          return 4
        when :interest
          return 2
        when :nonexistant
          return 0
        else
          ability_hash = get_ability_hash_for_type(char, ability_type)
          ability_hash[ability] || 0
      end
    end
    
    def self.get_related_apt(char, ability)
      ability_type = FS3Skills.get_ability_type(char, ability)
      default = Global.read_config("fs3skills", "default_related_apt")
      
      case ability_type
        when :action
          return FS3Skills.action_skills.find { |s| s["name"].upcase == ability.upcase }["related_apt"]
        when :advantage
          return FS3Skills.advantages.find { |s| s["name"].upcase == ability.upcase }["related_apt"]
        when :aptitude
          return ability
        else
          return char.fs3_related_apts[ability] || default
      end
    end
    
    def self.print_skill_rating(rating)
      case rating
      when 0
        return ""
      when 1
        return "%xg@%xn"
      when 2
        return "%xg@%xy@%xn"
      when 3
        return "%xg@%xy@%xr@%xn"
      when 4
        return "%xg@%xy@%xr@%xb@%xn"
      when 5
        return "%xg@%xy@%xr@%xb@%xc@%xn"
      end
    end
    
    def self.print_aptitude_rating(rating)
      case rating
      when 0
        "%xr#{t('fs3skills.aptitude_poor')}%xn"
      when 1
        "%xy#{t('fs3skills.aptitude_average')}%xn"
      when 2
        "%xg#{t('fs3skills.aptitude_good')}%xn"
      when 3
        "%xb#{t('fs3skills.aptitude_great')}%xn"
      end
    end

  end
end