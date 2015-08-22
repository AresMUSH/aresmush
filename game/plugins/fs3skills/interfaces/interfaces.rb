module AresMUSH
  module FS3Skills
    class RollParams
      
      attr_accessor :ability, :modifier, :ruling_apt
      
      def initialize(ability, modifier = 0, ruling_apt = nil)
        self.ability = ability
        self.modifier = modifier
        self.ruling_apt = ruling_apt
      end
    
      def to_s
        "#{self.ability} mod=#{self.modifier} ruling_apt=#{self.ruling_apt}"
      end
    end
    
    
    def self.advantages_enabled?
      Global.read_config("fs3skills", "enable_advantages")
    end
    
    # Expects titleized ability name
    # Makes an ability roll and returns the raw dice results.
    # Good for when you're doing a regular roll because you can show the raw dice and
    # use the other methods in this class to get the success level and title to display.
    def self.roll_ability(client, char, roll_params)
      dice = dice_to_roll_for_ability(char, roll_params)
      
      if (dice == 0 && client)
        client.emit_ooc t('fs3skills.confirm_zero_skill', :name => char.name, :ability => roll_params.ability)
      end
      
      roll = roll_dice(dice)
      Global.logger.info "#{char.name} rolling #{roll_params} dice=#{dice} result=#{roll}"
      roll
    end
    
    # Makes an ability roll and returns a hash with the successes and success title.
    # Good for automated systems where you only care about the final result and don't need
    # to know the raw die roll.
    def self.one_shot_roll(client, char, roll_params)
      roll = FS3Skills.roll_ability(client, char, roll_params)
      roll_result = FS3Skills.get_success_level(roll)
      success_title = FS3Skills.get_success_title(roll_result)
      
      {
        :successes => roll_result,
        :success_title => success_title
      }
    end
    
    # Rolls a raw number of dice.
    def self.one_shot_die_roll(dice)
      roll = FS3Skills.roll_dice(dice)
      roll_result = FS3Skills.get_success_level(roll)
      success_title = FS3Skills.get_success_title(roll_result)

      Global.logger.info "Rolling raw dice=#{dice} result=#{roll}"
      
      {
        :successes => roll_result,
        :success_title => success_title
      }
    end
    
    # Expects titleized ability name and numeric rating
    # Don't forget to save afterward!
    def self.set_ability(client, char, ability, rating)
      error = FS3Skills.check_ability_name(ability)
      if (!error.nil?)
        if (client)
          client.emit_failure error
        end
        return false
      end
      
      ability_type = get_ability_type(char, ability)
      ability_hash = get_ability_hash_for_type(char, ability_type)
      
      error = FS3Skills.check_rating(ability_type, rating)
      if (!error.nil?)
        if (client)
          client.emit_failure error
        end
        return false
      end
      
      update_hash(ability_hash, ability, rating)
      if (client)
        if (client.char == char)
          client.emit_success t("fs3skills.#{ability_type}_set", :name => ability, :rating => rating)
        else
          client.emit_success t("fs3skills.admin_ability_set", :name => char.name, :ability_type => ability_type, :ability_name => ability, :rating => rating)
        end
      end
      return true
    end
    
    # Don't forget to save afterward!
    def self.add_unrated_ability(client, char, ability, ability_type)
      list = FS3Skills.get_ability_list_for_type(char, ability_type)
      if (ability_type == :interest || ability_type == :expertise)
        other_list = FS3Skills.get_ability_list_for_type(char, ability_type == :interest ? :expertise : :interest)
      else
        other_list = []
      end
      
      if (list.include?(ability) || other_list.include?(ability))
        client.emit_failure t('fs3skills.item_already_selected', :name => ability)
        return false
      end
      
      list << ability
      client.emit_success t('fs3skills.item_selected', :name => ability)
      return true
    end
    
    # Rolls a number of FS3 dice and returns the raw die results.
    def self.roll_dice(dice)
      if (dice > 18)
        Global.logger.warn "Attempt to roll #{dice} dice."
        # Hey if they're rolling this many dice they ought to succeed spectacularly.
        return [9, 9, 9, 9, 9, 9]
      end
      
      dice = [dice, 1].max.ceil
      dice.times.collect { 1 + rand(10) }
    end
    
    # Determines the success level based on the raw die result.
    # Either:  0 for failure, -1 for a botch (embarrassing failure), or
    #    the number of successes.
    def self.get_success_level(die_result)
      successes = die_result.count { |d| d > 7 }
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
    
    # Expects titleized ability name and return ability rating.
    def self.ability_rating(char, ability)
      ability_type = FS3Skills.get_ability_type(char, ability)
      case ability_type
        when :expertise
          return 3
        when :interest
          ruling_apt = FS3Skills.get_ruling_apt(char, ability)
          rating = FS3Skills.ability_rating(char, ruling_apt)
          return rating
        when :untrained
          return 0
        when :aptitude
          ability_hash = get_ability_hash_for_type(char, ability_type)
          ability_hash[ability] - 1 || 0
        else
          ability_hash = get_ability_hash_for_type(char, ability_type)
          ability_hash[ability] || 0
      end
    end
    
    def self.get_ruling_apt(char, ability)
      ability_type = FS3Skills.get_ability_type(char, ability)
      default = Global.read_config("fs3skills", "default_ruling_apt")
      
      case ability_type
        when :action
          return FS3Skills.action_skills.find { |s| s["name"].upcase == ability.upcase }["ruling_apt"]
        when :advantage
          return FS3Skills.advantages.find { |s| s["name"].upcase == ability.upcase }["ruling_apt"]
        when :aptitude
          return ability
        else
          return char.fs3_ruling_apts[ability] || default
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
    
    
    def self.app_review(char)
      list = []
            
      text = FS3Skills.total_point_review(char)
      text << "%r"
      text << FS3Skills.high_ability_review(char)
      text << "%r"
      text << FS3Skills.interests_review(char)
      text << "%r%r"
      text << FS3Skills.aptitudes_set_review(char)
      text << "%r"
      text << FS3Skills.starting_language_review(char)
      text << "%r"
      text << FS3Skills.starting_skills_check(char)
      text << "%r"
      text << FS3Skills.hook_review(char)
      text << "%r"
      text << FS3Skills.goals_review(char)
      text
    end
  end
end