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

      Damage.create(:character => char,
        :descripton => desc,
        :current_severity => severity,
        :initial_severity => severity,
        :healing_points => FS3Combat.healing_points(severity),
        :is_stun => is_stun)
     end
     
     def self.healing_points(wound_level)
       Global.config["fs3combat"]["healing_points"][wound_level]
     end
     
     # If return is true, don't forget to save.
     def self.heal_wounds(char, heal_roll)
       unhealed_wounds = char.unhealed_wounds
       return false if unhealed_wounds.empty?

       ability = Global.config["fs3combat"]["toughness_attribute"]
       tough_roll = FS3Skills.one_shot_roll(nil, char, { :ability => ability, :ruling_attr => ability })

       points = ((heal_roll + tough_roll[:successes]) / 2.0).ceil
       
       Global.logger.info "Healing wounds on #{char.name}: #{heal_roll} #{tough_roll[:successes]}."
       
       unhealed_wounds.each do |d|
         d.heal(points, heal_roll > 0)
       end
       return true
     end
  end
end