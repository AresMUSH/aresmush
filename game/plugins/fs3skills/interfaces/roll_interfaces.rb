module AresMUSH
  module FS3Skills
    class RollParams
      
      attr_accessor :ability, :modifier, :related_apt
      
      def initialize(ability, modifier = 0, related_apt = nil)
        self.ability = ability
        self.modifier = modifier
        self.related_apt = related_apt
      end
    
      def to_s
        "#{self.ability} mod=#{self.modifier} related_apt=#{self.related_apt}"
      end
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

  end
end