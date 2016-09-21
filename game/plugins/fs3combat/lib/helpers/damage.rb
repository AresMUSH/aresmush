module AresMUSH
  module FS3Combat
    def self.damage_severities
      [ 'H', 'L', 'M', 'S', 'C' ]
    end
    
    def self.can_manage_damage?(actor)
      return actor.has_any_role?(Global.read_config("fs3combat", "roles", "can_manage_damage"))
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
    
    def self.inflict_damage(char, severity, desc, is_stun = false, is_mock = false)
      Global.logger.info "Damage inflicted on #{char.name}: #{desc} #{severity} stun=#{is_stun}"

      Damage.create(:character => char,
        :description => desc,
        :current_severity => severity,
        :initial_severity => severity,
        :ictime => ICTime::Api.ictime,
        :healing_points => FS3Combat.healing_points(severity),
        :is_stun => is_stun, 
        :is_mock => is_mock)
     end
     
     def self.healing_points(wound_level)
       Global.read_config("fs3combat", "healing_points", wound_level)
     end
     
     def self.print_damage(total_damage_mod)
       num_xs = [ total_damage_mod.ceil, 4 ].min
       dots = num_xs.times.collect { "X" }.join
       dashes = (4 - num_xs).times.collect { "-" }.join
       "#{dots}#{dashes}"
     end
     
     def self.total_damage_mod(wounds)
       mod = 0
       wounds.each do |w|
         mod = mod + w.wound_mod
       end
       mod
     end
     
     def self.treat_skill
       Global.read_config("fs3combat", "treat_skill")
     end
     
     def self.heal_wounds(char, wounds, was_treated = false, treat_roll = 0)
       return if wounds.empty?
       
       ability = Global.read_config("fs3combat", "toughness_attribute")
       roll_params = FS3Skills::RollParams.new(ability, 0, ability)
       tough_roll = FS3Skills::Api.one_shot_roll(nil, char, roll_params)

       points = ((treat_roll + tough_roll[:successes]) / 2.0).ceil
       
       Global.logger.info "Healing wounds on #{char.name}: #{treat_roll} #{tough_roll[:successes]}."
       
       wounds.each do |d|
         d.heal(points, was_treated)
       end
       return true
     end
     
     def self.do_treat(healer, patient)
       wounds = patient.treatable_wounds
       if (wounds.empty?)
         return t('fs3combat.no_treatable_wounds',  :healer => healer.name, :patient => patient.name)
       end
       
       roll_params = FS3Skills::RollParams.new(FS3Combat.treat_skill)
       roll = FS3Skills::Api.one_shot_roll(nil, healer, roll_params)
       
       successes = roll[:successes]
       Global.logger.info "Treat: #{healer.name} treating #{patient.name}: #{roll}"
       FS3Combat.heal_wounds(patient, wounds, true, successes)
       t('fs3combat.treat_success', :healer => healer.name, :patient => patient.name)
     end
  end
end