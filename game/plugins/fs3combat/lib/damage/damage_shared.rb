module AresMUSH
  module FS3Combat
    def self.damage_severities
      [ 'H', 'L', 'M', 'S', 'C' ]
    end
    
    def self.display_severity(value)
      case value
      when 'H'
        t('fs3combat.healed_wound')
      when 'L'
        t('fs3combat.light_wound')
      when 'M'
        t('fs3combat.moderate_wound')
      when 'S'
        t('fs3combat.serious_wound')
      when 'C'
        t('fs3combat.critical_wound')
      end
    end
    
    # Don't forget to save after!!
    def self.inflict_damage(char, severity, desc, is_stun)
      Global.logger.info "Damage inflicted on #{char.name}: #{desc} #{severity} stun=#{is_stun}"

      model.combat_damage << { "time" => Time.now, 
        "desc" => desc, 
        "current_severity" => severity,
        "initial_severity" => severity,
        "healing_points" => FS3Combat.healing_points(severity),
        "last_treated" => nil,
        "is_stun" => is_stun } 
     end
     
     def self.healing_points(wound_level)
       case wound_level
       when "L"
         2
       when "M"
         3
       when "S"
         4
       when "C"
         5
       else
         0
       end
     end
     
     def self.check_treat_frequency(char)
       return nil if char.last_treated.nil?
       time_to_go = 86400 - (Time.now - char.last_treated)
       return nil if time_to_go < 0
       return t('fs3combat.too_soon_to_treat', :name => char.name, :time => TimeFormatter.format(time_to_go.to_i))
     end
     
     # If return is true, don't forget to save.
     def self.heal_wounds(char, heal_roll)
       
       unhealed_wounds = char.combat_damage.select {|d| d["healing_points"] > 0} 
       return false if unhealed_wounds.empty?

       ability = Global.config["fs3combat"]["toughness_attribute"]
       tough_roll = FS3Skills.one_shot_roll(nil, char, { :ability => ability, :ruling_attr => ability })

       points = ((heal_roll + tough_roll[:successes]) / 2.0).ceil
       
       Global.logger.info "Healing wounds on #{char.name}: #{heal_roll} #{tough_roll[:successes]}."
       
       unhealed_wounds.each do |d|
         # Apply healing points
         d["healing_points"] = d["healing_points"] - points
         
         # Wound going down a level.
         if (d["healing_points"] <= 0)
           new_severity_index = FS3Combat.damage_severities.index(d["current_severity"]) - 1
           new_severity = FS3Combat.damage_severities[new_severity_index]
           d["current_severity"] = new_severity
           d["healing_points"] = FS3Combat.healing_points(new_severity)
         end
       end
       return true
     end
  end
end