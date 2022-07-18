module AresMUSH
  module FS3Skills
    def self.can_manage_xp?(actor)
      actor && actor.has_permission?("manage_abilities")
    end
    
    def self.modify_xp(char, amount)
      max_xp = Global.read_config("fs3skills", "max_xp_hoard")
      xp = char.xp + amount
      xp = [max_xp, xp].min
      xp = [0, xp].max
      char.update(fs3_xp: xp)
    end
    
    def self.days_between_learning
      Global.read_config("fs3skills", "days_between_learning")
    end
    
    def self.xp_needed(ability_name, rating)
      ability_type = FS3Skills.get_ability_type(ability_name)
      costs = Global.read_config("fs3skills", "xp_costs")
      costs = costs[ability_type.to_s]
      # Goofiness needed because XP keys could be either strings or integers.
      key = costs.keys.select { |r| r.to_s == rating.to_s }.first
      key ? costs[key] : nil
    end
    
    def self.days_to_next_learn(ability)
      (ability.time_to_next_learn / 86400).ceil
    end
    
    def self.check_can_learn(char, ability_name, rating)
      return t('fs3skills.cant_raise_further_with_xp') if self.xp_needed(ability_name, rating) == nil

      ability_type = FS3Skills.get_ability_type(ability_name)
      
      if (ability_type == :attribute)
        # Attrs cost 2 points per dot
        dots_beyond_chargen = Global.read_config("fs3skills", "attr_dots_beyond_chargen_max") || 2
        max = Global.read_config("fs3skills", "max_points_on_attrs") + (dots_beyond_chargen * 2)
        points = AbilityPointCounter.points_on_attrs(char)
        new_total = points + 2
      elsif (ability_type == :action)
        dots_beyond_chargen = Global.read_config("fs3skills", "action_dots_beyond_chargen_max") || 3
        max = Global.read_config("fs3skills", "max_points_on_action") + dots_beyond_chargen
        points = AbilityPointCounter.points_on_action(char)
        new_total = points + 1
      elsif (ability_type == :advantage)
        dots_beyond_chargen = Global.read_config("fs3skills", "advantage_dots_beyond_chargen_max") || 3
        cost = Global.read_config("fs3skills", "advantages_cost")
        max = (Global.read_config("fs3skills", "max_points_on_advantages") || 99) + (dots_beyond_chargen * cost)
        points = AbilityPointCounter.points_on_advantages(char)
        new_total = points + 1
      else
        return nil
      end
      
      return max >= new_total ? nil : t('fs3skills.max_ability_points_reached')
    end
    
    def self.learn_ability(char, name)
      return t('fs3skills.not_enough_xp') if char.xp <= 0
      
      ability = FS3Skills.find_ability(char, name)
      
      ability_type = FS3Skills.get_ability_type(name)
      if (ability_type == :advantage && !Global.read_config("fs3skills", "allow_advantages_xp"))
        return t('fs3skills.cant_learn_advantages_xp')
      end
      
      if (!ability)
        error = FS3Skills.set_ability(char, name, 1)
        if (error)
          return error
        end
        ability = FS3Skills.find_ability(char, name)
        FS3Skills.create_xp_job(char, ability)
      else
        
        error = FS3Skills.check_can_learn(char, name, ability.rating)
        if (error)
          return error
        end

        if (!ability.can_learn?)
          time_left = FS3Skills.days_to_next_learn(ability)
          return t('fs3skills.cant_raise_yet', :days => time_left)
        end
        
        ability.learn
        
        if (ability.learning_complete)
          ability.update(xp: 0, rating: ability.rating + 1)
          FS3Skills.create_xp_job(char, ability)
        end
        
      end 
      
      
      FS3Skills.modify_xp(char, -1)       
      return nil
    end
    
    def self.create_xp_job(char, ability)
      message = t('fs3skills.xp_raised_job', :name => char.name, :ability => ability.name, :rating => ability.rating)
      category = Jobs.system_category
      status = Jobs.create_job(category, t('fs3skills.xp_job_title', :name => char.name), message, Game.master.system_character)        
      if (status[:job])
        Jobs.close_job(Game.master.system_character, status[:job])
      end
    end
    
    def self.max_dots_in_action
      base = Global.read_config("fs3skills", 'max_points_on_action') || 0
      extra = Global.read_config("fs3skills", 'action_dots_beyond_chargen_max') || 0
      base + extra
    end
    
    def self.max_dots_in_attrs
      base = (Global.read_config("fs3skills", 'max_points_on_attrs') || 0) / 2
      extra = Global.read_config("fs3skills", 'attr_dots_beyond_chargen_max') || 0
      base + extra
    end
    
    def self.max_dots_in_advantages
      cost = Global.read_config("fs3skills", "advantages_cost")
      base = (Global.read_config("fs3skills", 'max_points_on_advantages') || 0) / cost
      extra = Global.read_config("fs3skills", 'advantage_dots_beyond_chargen_max') || 0
      base + extra
    end
  end
end