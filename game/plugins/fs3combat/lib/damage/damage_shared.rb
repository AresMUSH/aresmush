module AresMUSH
  module FS3Combat
    def self.damage_severities
      [ 'H', 'L', 'M', 'S', 'C' ]
    end
    
    def self.can_manage_damage?(actor)
      return actor.has_any_role?(Global.config["fs3combat"]["roles"]["can_manage_damage"])
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
        :description => desc,
        :current_severity => severity,
        :initial_severity => severity,
        :healing_points => FS3Combat.healing_points(severity),
        :is_stun => is_stun)
     end
     
     def self.healing_points(wound_level)
       Global.config["fs3combat"]["healing_points"][wound_level]
     end
     
     def self.heal_wounds(char, wounds, treat_roll = 0)
       return if wounds.empty?
       
       ability = Global.config["fs3combat"]["toughness_attribute"]
       tough_roll = FS3Skills.one_shot_roll(nil, char, { :ability => ability, :ruling_attr => ability })

       points = ((treat_roll + tough_roll[:successes]) / 2.0).ceil
       
       Global.logger.info "Healing wounds on #{char.name}: #{treat_roll} #{tough_roll[:successes]}."
       
       wounds.each do |d|
         d.heal(points, treat_roll > 0)
       end
       return true
     end
  end
end