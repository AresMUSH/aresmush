module AresMUSH
  module FS3Combat
    class FS3CombatConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("fs3combat")
      end
      
      def validate
        
        begin
          
          check_weapons
          check_armor
          check_hitloc
          check_vehicles
          check_damage
          check_mounts
          check_npcs
          check_skills
          check_misc
          
        
      
        rescue Exception => ex
          @validator.add_error "Unknown FS3Combat config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0]}"
          
        end
        
        @validator.errors
      end

      def check_damage
        @validator.require_hash 'damage_mods'
        @validator.require_hash 'damage_table'
        @validator.check_cron 'healing_cron'
        @validator.require_hash 'healing_points'
        @validator.require_int 'pc_knockout_bonus', 0
        
        Global.read_config('fs3combat', 'damage_mods').each do |k, v|
          if (v < 0)
            @validator.add_error "fs3combat:damage_mods #{k} must have a numeric mod > 0."
          end
        end
        
        prior_mod = -1
        Global.read_config('fs3combat', 'damage_table').each do |k, v|
          if (!(v.kind_of?(Integer) || v.kind_of?(Float)))
            @validator.add_error "fs3combat:damage_table #{k} must have a numeric value."
          end
          if (v < 0)
            @validator.add_error "fs3combat:damage_table #{k} must be greater than 0."
          end
          if (v < prior_mod)
            @validator.add_error "fs3combat:damage_table #{k} must be greater than the prior entry."
          end
          prior_mod = v
        end
        
        Global.read_config('fs3combat', 'healing_points').each do |k, v|
          if (!(v.kind_of?(Integer) || v.kind_of?(Float)))
            @validator.add_error "fs3combat:healing_points #{k} must have a numeric value."
          end
          if (v < 0)
            @validator.add_error "fs3combat:healing_points #{k} must be greater than 0."
          end
        end
      end
      
      def check_weapons
        @validator.require_hash('weapons')
        FS3Combat.weapons.each do |name, data|
          [ 'description', 'skill', 'lethality', 'penetration', 'weapon_type', 'recoil', 
            'damage_type', 'accuracy', 'init_mod' ].each do |prop|
              verify_property_exists(name, data, prop)
            end
        
            [ 'lethality', 'ammo', 'penetration', 'recoil', 'accuracy', 'init_mod' ].each do |prop|
              verify_integer(name, data, prop)
            end
        
            [ 'recoil', 'accuracy', 'init_mod' ].each do |prop|
              verify_mod_range(name, data, prop)
            end
        
            verify_percentage(name, data, 'lethality')
        
            if (!data['skill'].kind_of?(Integer))
              verify_action_skill(name, data, 'skill')
            end
        
        end
      
        if (!FS3Combat.weapons.keys.include?("Shrapnel"))
          @validator.add_error "fs3combat:weapons The Sharpnel weapon cannot be removed or renamed."
        end
      end
      
      def check_armor
        @validator.require_hash('armor')
        
        FS3Combat.armors.each do |name, data|
          [ 'description', 'defense', 'protection' ].each do |prop|
            verify_property_exists(name, data, prop)
          end
      
          verify_integer(name, data, 'defense')
      
          if (data['protection'].class != Hash)
            @validator.add_error "fs3combat:armor #{name}'s protection should list hitlocs and protection values, like Head: 4"
          end
        end
      end
      
      def check_hitloc
        @validator.require_hash('hitloc')
        FS3Combat.hitloc_charts.each do |name, data|
          [ 'vital_areas', 'critical_areas', 'areas' ].each do |prop|
            verify_property_exists(name, data, prop)
          end
      
          data['areas'].each do |area, hitlocs|
            if (hitlocs.count != 10)
              @validator.add_error "fs3combat:hitloc #{name}'s #{area} hitloc should have 10 areas listed."
            end
            if (hitlocs[-1] != area)
              @validator.add_error "fs3combat:hitloc #{name}'s #{area} hitloc should have #{area} in the highest position."
            end
          end
      
          if (data['vital_areas'].class != Array)
            @validator.add_error "fs3combat:hitloc #{name}'s vital areas is not a list."
          end
      
          if (data['critical_areas'].class != Array)
            @validator.add_error "fs3combat:hitloc #{name}'s critical areas is not a list."
          end
        end
      end
      
      def check_vehicles
        @validator.require_hash 'vehicles'
        FS3Combat.vehicles.each do |name, data|
          [ 'description', 'pilot_skill', 'toughness', 'hitloc_chart', 'armor', 'weapons', 'dodge' ].each do |prop|
            verify_property_exists(name, data, prop)
          end
      
          [ 'dodge', 'toughness' ].each do |prop|
            verify_integer(name, data, prop)
            verify_mod_range(name, data, prop)
          end
      
          if (!data['pilot_skill'].kind_of?(Integer))
            verify_action_skill(name, data, 'pilot_skill')
          end
      
          if (!FS3Combat.hitloc_charts.keys.include?(data['hitloc_chart']))
            @validator.add_error "fs3combat:vehicles #{name}'s hit location chart doesn't exist."
          end
      
          if (!FS3Combat.armors.keys.include?(data['armor']))
            @validator.add_error "fs3combat:vehicles #{name}'s armor type doesn't exist."
          end
        end
      end
      
      def check_mounts
        @validator.require_hash('mounts')
        FS3Combat.mounts.each do |name, data|
          [ 'description', 'toughness', 'mod_vs_unmounted' ].each do |prop|
            verify_property_exists(name, data, prop)
          end
      
          [ 'toughness' ].each do |prop|
            verify_integer(name, data, prop)
            verify_ability_range(name, data, prop)
          end
          
          [ 'mod_vs_unmounted' ].each do |prop|
            verify_integer(name, data, prop)
            verify_mod_range(name, data, prop)
          end
        end
      end
      
      def check_npcs
        @validator.require_hash('npc_types')
        @validator.require_nonblank_text('default_npc_type')
        npc_types = Global.read_config("fs3combat", "npc_types")
        
        if (!npc_types.has_key?(Global.read_config('fs3combat', 'default_npc_type')))
          @validator.add_error "fs3combat:default_npc_type is not a valid NPC type."
        end
        
        npc_types.each do |name, data|
          if !data.has_key?("Default")
            @validator.add_error "fs3combat:npc_types #{name} is missing a Default ability level."
          end
          data.each do |k, v|
            if (!v.kind_of? Integer)
              @validator.add_error "fs3combat:npc_types #{name}'s #{k} should be a whole number."
            end
            if (k != 'Wounds' && (v > 15 || v < 0))
              @validator.add_error "fs3combat:npc_types #{name}'s #{k} should be 1 to 15."
            end
          end
        end
      end
      
      def check_skills
        ['treat_skill', 'healing_skill', 'recovery_skill', 'initiative_skill', 'composure_skill',
          'strength_skill', 'default_defense_skill'].each do |skill|
          @validator.require_nonblank_text(skill)
          abilities = FS3Skills.action_skill_names.concat(FS3Skills.attr_names)
          @validator.require_in_list(skill, abilities)
        end
      end
      
      def check_misc
        @validator.require_nonblank_text('default_type')
        @validator.require_boolean('allow_vehicles')
        @validator.require_boolean('allow_mounts')
        @validator.require_hash('stances')
        @validator.require_hash('combatant_types')
        @validator.require_in_list('default_type', FS3Combat.combatant_types)

        Global.read_config('fs3combat', 'stances').each do |name, mods|
          mods.each do |mod, value|
            if (mod != 'attack_mod' && mod != 'defense_mod')
              @validator.add_error "fs3combat:stances #{name} has an unrecognized modifier type."
            end
            if (value > 6 || value < -6)
              @validator.add_error "fs3combat #{name}'s #{mod} modifier should be +/- 1 to 6."
            end
          end
        end
        
        types = Global.read_config('fs3combat', 'combatant_types')
        
        if (!types.has_key?("Observer"))
          @validator.add_error "fs3combat:combatant_types Observer type is missing."
        end
        
        types.each do |name, data|
          if (!data['hitloc'] || !FS3Combat.hitloc_chart_for_type(data['hitloc']))
            @validator.add_error "fs3combat:combatant_types #{name} has an invalid hitloc table."
          end
          if (data['vehicle'] && !FS3Combat.vehicle(data['vehicle']))
            @validator.add_error "fs3combat:combatant_types #{name} has an invalid vehicle."
          end
          if (data['weapon'] && !FS3Combat.weapon(data['weapon']))
            @validator.add_error "fs3combat:combatant_types #{name} has an invalid weapon."
          end
          if (data['armor'] && !FS3Combat.armor(data['armor']))
            @validator.add_error "fs3combat:combatant_types #{name} has invalid armor."
          end
          
          if (!data['vehicle'] && !data['weapon'] && name != "Observer")
            @validator.add_error "fs3combat:combatant_types #{name} needs either a weapon or a vehicle."
          end
          
          specials = data['weapon_specials']
          if (specials) 
            allowed_specials = FS3Combat.weapon_stat(data['weapon'], 'allowed_specials') || []
            specials.each do |s|
              if (!allowed_specials.include?(s))
                @validator.add_error "fs3combat:combatant_types #{name} has invalid specials for their weapon."
              end
            end
          end
          
          abilities = FS3Skills.action_skill_names.concat(FS3Skills.attr_names)
          defense = data['defense_skill']
          if (defense && !abilities.include?(defense))
            @validator.add_error "fs3combat:combatant_types #{name} has invalid defense ability."
          end
        end
      end
      
      def verify_property_exists(name, data, prop)
        if (!data[prop])
          @validator.add_error "fs3combat #{name} missing #{prop}." 
        end
      end
    
      def verify_integer(name, data, prop)
        return if !data[prop]
        if (data[prop].class != Integer )
          @validator.add_error "fs3combat #{name}'s #{prop} should be a whole number."
        end
      end
    
      def verify_mod_range(name, data, prop)
        return if !data[prop]
        return if (data[prop].class != Integer )
      
        if (data[prop] > 6 || data[prop] < -6)
          @validator.add_error "fs3combat #{name}'s #{prop} modifier should be +/- 1 to 6."
        end
      end
      
      def verify_ability_range(name, data, prop)
        return if !data[prop]
        return if (data[prop].class != Integer )
      
        if (data[prop] > 15 || data[prop] < 0)
          @validator.add_error "fs3combat #{name}'s #{prop} should be 1 to 15."
        end
      end
    
      def verify_percentage(name, data, prop)
        return if !data[prop]
        return if (data[prop].class != Integer )
      
        if (data[prop] < 3 && data[prop] != 0 && data[prop] > -3)
          @validator.add_error "fs3combat #{name}'s #{prop} should be a percentage."
        end
      end
    
      def verify_action_skill(name, data, prop)
        skills = FS3Skills.action_skill_names
        if (!skills.include?(data[prop]))
          @validator.add_error "fs3combat #{name}'s #{prop} is not an action skill."
        end
      end
    end
  end
end