module AresMUSH
  module FS3Skills
    def self.can_manage_xp?(actor)
      actor.has_any_role?(Global.read_config("fs3skills", "can_manage_xp"))
    end
    
    def self.modify_xp(char, amount)
      max_xp = Global.read_config("fs3skills", "max_xp_hoard")
      xp = char.xp + amount
      xp = [max_xp, xp].min
      char.update(fs3_xp: xp)
    end
    
    def self.days_between_learning
      Global.read_config("fs3skills", "days_between_learning")
    end
    
    def self.xp_needed(ability_name, rating)
      ability_type = FS3Skills.get_ability_type(ability_name)
      costs = Global.read_config("fs3skills", "xp_costs")
      costs[ability_type.to_s][rating] || 99
    end
    
    def self.can_learn_further?(name, rating)
      ability_type = FS3Skills.get_ability_type(name)
      max_rating = FS3Skills.get_max_rating(ability_type)

      rating < max_rating
    end
    
    def self.learn_ability(client, char, name)
      ability = FS3Skills.find_ability(char, name)
      
      if (!ability)
        FS3Skills.set_ability(client, char, name, 1)
      else
        
        if (!FS3Skills.can_learn_further?(name, ability.rating))
          client.emit_failure t('fs3skills.cant_raise_further_with_xp')
          return
        end

        if (!ability.can_learn?)
          time_left = ability.time_to_next_learn / 86400
          client.emit_failure t('fs3skills.cant_raise_yet', :days => time_left.ceil)
          return
        end
        
        ability.learn
        if (ability.learning_complete)
          ability.update(xp: 0)
          FS3Skills.set_ability(client, char, name, ability.rating + 1)
          message = t('fs3skills.xp_raised_job', :name => char.name, :ability => name, :rating => ability.rating + 1)
          Jobs.create_job("REQ", t('fs3skills.xp_job_title'), message, Game.master.system_character)
        else
          client.emit_success t('fs3skills.xp_spent', :name => name)
        end
      end 
      
      FS3Skills.modify_xp(char, -1)       
    end
  end
end