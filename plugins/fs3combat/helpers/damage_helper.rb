module AresMUSH
  module FS3Combat
    def self.damage_severities
      # Deliberately leaves off GRAZE wounds as they're not tracked and shouldn't
      # ever be assigned through damage/inflict.
      [ 'HEAL', 'FLESH', 'IMPAIR', 'INCAP' ]
    end
    
    def self.can_manage_damage?(actor)
      actor && actor.has_permission?("manage_combat")
    end
    
    def self.display_severity(value)
      case value
      when 'HEAL'
        t('fs3combat.healed_wound')
      when 'GRAZE'
        t('fs3combat.graze_wound')
      when 'FLESH'
        t('fs3combat.flesh_wound')
      when 'IMPAIR'
        t('fs3combat.impaired_wound')
      when 'INCAP'
        t('fs3combat.incap_wound')
      end
    end
    
    def self.can_inflict_damage(enactor, target)
      target_combat = target.combat
      enactor_combat = enactor.combat
      return true if FS3Combat.can_manage_damage?(enactor)
      return false if !target_combat
      return false if target_combat != enactor_combat
      enactor_combat.organizer  == enactor
    end
      
    def self.inflict_damage(target, severity, desc, is_stun = false, is_mock = false)
      Global.logger.info "Damage inflicted on #{target.name}: #{desc} #{severity} stun=#{is_stun}"

      # Graze wounds aren't saved.
      return if severity == "GRAZE"
      
      params = {
        :description => desc,
        :current_severity => severity,
        :initial_severity => severity,
        :ictime_str => ICTime.ic_datestr(ICTime.ictime),
        :healing_points => FS3Combat.healing_points(severity),
        :is_stun => is_stun, 
        :is_mock => is_mock
      }
      if (target.class == Character)
        params[:character] = target
      elsif (target.class == Vehicle)
        params[:vehicle] = target
      else
        params[:npc] = target
      end
      
      Damage.create(params)
      FS3Combat.award_damage_achievement(target, is_mock)
     end
     
     def self.healing_points(wound_level)
       Global.read_config("fs3combat", "healing_points", wound_level)
     end
     
     def self.print_damage(total_damage_mod)
       rounded_damage = (-total_damage_mod).ceil
       num_xs = [ rounded_damage, 4 ].min
       dots = num_xs.times.collect { "X" }.join
       dashes = (4 - num_xs).times.collect { "-" }.join
       "%xr#{dots}%xn#{dashes}"
     end
     
     def self.total_damage_mod(char_or_npc)
       mod = 0
       char_or_npc.damage.each do |w|
         mod = mod + w.wound_mod
       end
       -mod.round(2)
     end
     
     def self.treat_skill
       Global.read_config("fs3combat", "treat_skill")
     end
     
     def self.healing_skill
       Global.read_config("fs3combat", "healing_skill")
     end
     
     def self.max_patients(char)
       rating = FS3Skills.ability_rating(char, FS3Combat.healing_skill)
       rating / 2
     end
     
     def self.heal_wounds(char)
       wounds = char.damage.select { |d| d.healing_points > 0 } 
       return if wounds.empty?
       
       ability = Global.read_config("fs3combat", "recovery_skill")
       roll_params = FS3Skills::RollParams.new(ability)
       recovery_roll = FS3Skills.one_shot_roll(char, roll_params)
       doctors = char.doctors.map { |d| d.name }
       
       points = 1
       
       if (doctors.count > 0 || recovery_roll[:successes] > 0)
         points += 1
       end
       
       Global.logger.info "Healing wounds on #{char.name}: docs=#{doctors.join(",")} recovery=#{recovery_roll[:successes]}."
       
       wounds.each do |d|
         FS3Combat.heal(d, points)
       end
     end
     
     def self.worst_treatable_wound(char_or_npc)
       treatable = char_or_npc.damage.select { |d| d.is_treatable? }
       return nil if treatable.empty?

              
       treatable.sort_by { |d| FS3Combat.damage_severities.index(d.current_severity) }.reverse.first
     end
     
     def self.treat(patient_char_or_npc, healer_char_or_npc)
       wound = FS3Combat.worst_treatable_wound(patient_char_or_npc)
       healer_name = healer_char_or_npc.name
       patient_name = patient_char_or_npc.name
       
       if (!wound)
         return t('fs3combat.no_treatable_wounds', :healer => healer_name, :patient => patient_name)
       end
       
       skill = FS3Combat.treat_skill 
       
       roll = healer_char_or_npc.roll_ability(skill)
       successes = roll[:successes]
       
       
       if (successes <= 0)
         return t('fs3combat.treat_failed', :healer => healer_name, :patient => patient_name)
       end
       
       combat = FS3Combat.combat(healer_name)
       if (combat)
         combat.log "Treat: #{healer_name} treating #{patient_name}: #{roll}"
       else
         Global.logger.info "Treat: #{healer_name} treating #{patient_name}: #{roll}"
       end
       
       FS3Combat.heal(wound, 1)
       t('fs3combat.treat_success', :healer => healer_name, :patient => patient_name)
     end
     
    
     def self.heal(wound, points)
       healing = wound.healing_points
       return if healing == 0

       if (wound.is_stun)
         wound.update(current_severity: "HEAL")
         wound.update(healing_points: 0)
         wound.update(healed: true)
         return
       end
       
       healing = healing - points      

       # Wound going down a level.
       if (healing <= 0)
         new_severity_index = FS3Combat.damage_severities.index(wound.current_severity) - 1
         new_severity = FS3Combat.damage_severities[new_severity_index]
         wound.update(current_severity: new_severity)
         wound.update(healing_points: FS3Combat.healing_points(new_severity))
       else
         wound.update(healing_points: healing)
       end

       wound.update(healed: true)
     end
     
     def self.award_damage_achievement(target, is_mock)
       return if target.class != Character
       return if is_mock
       
       damage_count = target.damage.count
       [ 1, 5, 10, 20, 50, 100 ].reverse.each do |count|
         if (damage_count >= count)
           Achievements.award_achievement(target, "fs3_wounded", count)
           break
         end
       end  
     end
     
  
  end
end