module AresMUSH
  module FS3Skills
    # Expects titleized ability name
    def self.roll_ability(client, char, roll_params)
      ability = roll_params[:ability]
      ruling_attr = roll_params[:ruling_attr] || FS3Skills.get_ruling_attr(char, ability)
      modifier = roll_params[:modifier] || 0
      
      skill = FS3Skills.ability_rating(char, ability)
      
      if (skill == 0 && !client.nil?)
        client.emit_ooc t('fs3skills.confirm_zero_skill', :name => char.name, :ability => ability)
      end

      attr_rating = FS3Skills.ability_rating(char, ruling_attr)
      dice = skill + attr_rating + modifier
      roll = roll_dice(dice)
      Global.logger.info "#{char.name} rolling #{ability} (#{skill}) mod #{modifier} attr #{ruling_attr} (#{attr_rating}) dice=#{dice} result=#{roll}"
      roll
    end
    
    def self.one_shot_roll(client, char, roll_params)
      roll = FS3Skills.roll_ability(client, char, roll_params)
      roll_result = FS3Skills.get_success_level(roll)
      success_title = FS3Skills.get_success_title(roll_result)
      
      {
        :successes => roll_result,
        :success_title => success_title
      }
    end
    
    # Expects titleized ability name and numeric rating
    # Don't forget to save afterward!
    def self.set_ability(client, char, ability, rating)
      ability_type = get_ability_type(ability)
      ability_hash = get_ability_hash(char, ability_type)
      
      error = FS3Skills.check_ability_name(ability)
      if (!error.nil?)
        client.emit_failure error
        return false
      end
      
      error = FS3Skills.check_rating(ability_type, rating)
      if (!error.nil?)
        client.emit_failure error
        return false
      end
      
      update_hash(ability_hash, ability, rating)
      if (client.char == char)
        client.emit_success t("fs3skills.#{ability_type}_set", :name => ability, :rating => rating)
      else
        client.emit_success t("fs3skills.admin_ability_set", :name => char.name, :ability_type => ability_type, :ability_name => ability, :rating => rating)
      end
      return true
    end
    
    # Don't forget to save afterward!
    def self.add_language(client, char, language)
      if (char.fs3_languages.include?(language))
        client.emit_failure t('fs3skills.language_already_selected')
        return false
      end
      
      char.fs3_languages << language
      client.emit_success t('fs3skills.language_selected', :name => language)
      return true
    end
    
    def self.roll_dice(dice)
      if (dice > 20)
        Global.logger.warn "Attempt to roll #{dice} dice."
        return [1]
      end
      dice = [dice, 1].max
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
      when 6..99
        t('fs3skills.amazing_success')
      else
        raise "Unexpected roll result: #{success_level}"
      end
    end
    
    def self.opposed_result_title(name1, successes1, name2, successes2)
      delta = successes1 - successes2
      
      if (successes1 <=0 && successes2 <= 0)
        return t('fs3skills.opposed_both_fail')
      end
      
      case delta
      when 4..99
        return t('fs3skills.opposed_crushing_victory', :name => name1)
      when 2, 3
        return t('fs3skills.opposed_victory', :name => name1)
      when 1
        return t('fs3skills.opposed_marginal_victory', :name => name1)
      when 0
        return t('fs3skills.opposed_draw')
      when -1
        return t('fs3skills.opposed_marginal_victory', :name => name2)
      when -2
        return t('fs3skills.opposed_victory', :name => name2)
      when -99..-3
        return t('fs3skills.opposed_crushing_victory', :name => name2)
      else
        raise "Unexpected opposed roll result: #{successes1} #{successes2}"
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
      elsif (ability_type == :attribute)
        return ability
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
    
    def self.app_review(char)
      list = []
      
      attrs = FS3Skills.points_on_abilities(char, :attribute)
      action = FS3Skills.points_on_abilities(char, :action)
      bg = FS3Skills.points_on_abilities(char, :background)
      
      num_languages = char.fs3_languages.count
      
      text = FS3Skills.total_point_review(attrs + action + bg + (num_languages * 2))
      text << "%r"
      text << FS3Skills.attr_review(attrs)
      text << "%r"
      text << FS3Skills.action_skill_review(action)
      text << "%r%r"
      text << FS3Skills.bg_skill_review(char)
      text << "%r"
      text << FS3Skills.high_ability_review(char)
      text << "%r"
      text << FS3Skills.quirk_review(char)
      text << "%r%r"
      text << FS3Skills.min_attr_review(char)
      text << "%r"
      text << FS3Skills.starting_language_review(char)
      text << "%r"
      text << FS3Skills.starting_skills_check(char)
      text
    end
  end
end