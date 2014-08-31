module AresMUSH
  module FS3Skills
    # Expects titleized ability name
    def self.roll_ability(char, ability, modifier = 0, ruling_attr = nil)
      skill = FS3Skills.ability_rating(char, ability)
      if (ruling_attr.nil?)
        ruling_attr = FS3Skills.get_ruling_attr(char, ability)
      end
      attr_rating = FS3Skills.ability_rating(char, ruling_attr)
      dice = skill + attr_rating + modifier
      Global.logger.info "#{char.name} rolling #{ability} with #{modifier}: attr #{ruling_attr} (#{attr_rating}) dice=#{dice}"
      roll_dice(dice)
    end
    
    def self.roll_dice(dice)
      dice.times.collect { 1 + rand(8) }
    end
    
    def self.get_success_level(die_result)
      successes = die_result.count { |d| d > 6 }
      botches = die_result.count { |d| d == 1 }
      return successes if (successes > 0)
      return -1 if (botches > 2)
      return 0
    end
    
    def self.get_success_title(success_level)
      case success_level
      when -1
        t('fs3skills.embarrassing_failure')
      when 0
        t('fs3skills.failure')
      when 1
        t('fs3skills.success')
      when 2, 3
        t('fs3skills.good_success')
      when 4, 5
        t('fs3skills.great_success')
      else
        t('fs3skills.amazing_success')
      end
    end
    
    # Expects titleized ability name
    def self.ability_rating(char, ability)
      hash = FS3Skills.get_ability(char, ability)
      hash.nil? ? 0 : hash["rating"]
    end
    
    def self.get_ruling_attr(char, ability)
      ability_type = FS3Skills.get_ability_type(ability)
      default = Global.config['fs3skills']['default_ruling_attr']
      if (ability_type == :action)
        return FS3Skills.action_skills.find { |s| s["name"] == ability }["ruling_attr"]
      end
      
      hash = FS3Skills.get_ability(char, ability)
      return default if hash.nil?
      return default if hash['ruling_attr'].nil?
      return hash["ruling_attr"]
    end
    
    def self.print_skill_rating(rating)
      num_dots = [rating, 3].min
      dots = print_dots(num_dots, "%xg")

      if (rating > 3)
        num_dots = [rating - 3, 3].min
        dots = dots + print_dots(num_dots, "%xy")
      end
      
      if (rating > 6)
        num_dots = [rating - 6, 3].min
        dots = dots + print_dots(num_dots, "%xr")
      end
      
      if (rating > 9)
        num_dots = [rating - 9, 3].min
        dots = dots + print_dots(num_dots, "%xb")
      end
      dots
    end
    
    def self.print_attribute_rating(rating)
      case rating
      when 0
        ""
      when 1
        "%xg@%xn"
      when 2
        "%xg@%xy@%xn"
      when 3
        "%xg@%xy@%xr@%xn"
      when 4
        "%xg@%xy@%xr@%xb@%xn"
      end
    end
    
    def self.print_dots(number, color)
      dots = number.times.collect { "@" }.join
      "#{color}#{dots}%xn"
    end
  end
end