module AresMUSH
  module FS3Combat
    class GearCheckCmd
      include CommandHandler
      
      def handle
        warnings = []
        FS3Combat.weapons.each do |name, data|
          [ 'description', 'skill', 'lethality', 'penetration', 'weapon_type', 'recoil', 
            'damage_type', 'accuracy', 'init_mod' ].each do |prop|
            verify_property_exists(name, data, prop, warnings)
          end
          
          [ 'lethality', 'ammo', 'penetration', 'recoil', 'accuracy', 'init_mod' ].each do |prop|
            verify_integer(name, data, prop, warnings)
          end
          
          [ 'recoil', 'accuracy', 'init_mod' ].each do |prop|
            verify_ability_range(name, data, prop, warnings)
          end
          
          verify_percentage(name, data, 'lethality', warnings)
          
          verify_action_skill(name, data, 'skill', warnings)
          
        end
        
        if (!FS3Combat.weapons.keys.include?("Shrapnel"))
          warnings<< "You seem to have deleted the Shrapnel weapon.  It's necessary."
        end
        
        FS3Combat.armors.each do |name, data|
          [ 'description', 'defense', 'protection' ].each do |prop|
            verify_property_exists(name, data, prop, warnings)
          end
          
          verify_integer(name, data, 'defense', warnings)
          
          if (data['protection'].class != Hash)
            warnings << "#{name}'s protection should list hitlocs and protection values, like Head: 4"
          end
        end
        
        FS3Combat.hitloc_charts.each do |name, data|
          [ 'vital_areas', 'critical_areas', 'areas' ].each do |prop|
            verify_property_exists(name, data, prop, warnings)
          end
          
          data['areas'].each do |area, hitlocs|
            if (hitlocs.count != 10)
              warnings << "#{name}'s #{area} hitloc doesn't have 10 areas listed."
            end
            if (hitlocs[-1] != area)
              warnings << "#{name}'s #{area} hitloc doesn't have #{area} in the highest positions."
            end
          end
          
          if (data['vital_areas'].class != Array)
            warnings << "#{name}'s vital areas is not a list."
          end
          
          if (data['critical_areas'].class != Array)
            warnings << "#{name}'s critical areas is not a list."
          end
        end
        
        FS3Combat.vehicles.each do |name, data|
          [ 'description', 'pilot_skill', 'toughness', 'hitloc_chart', 'armor', 'weapons', 'dodge' ].each do |prop|
            verify_property_exists(name, data, prop, warnings)
          end
          
          [ 'toughness', 'dodge' ].each do |prop|
            verify_integer(name, data, prop, warnings)
            verify_ability_range(name, data, prop, warnings)
          end
          
          verify_action_skill(name, data, 'pilot_skill', warnings)

          
          if (!FS3Combat.hitloc_charts.keys.include?(data['hitloc_chart']))
            warnings << "#{name}'s hit location chart doesn't exist."
          end
          
          if (!FS3Combat.armors.keys.include?(data['armor']))
            warnings << "#{name}'s armor type doesn't exist."
          end
          
        end
        
        template = BorderedListTemplate.new(warnings)
        client.emit template.render
      end
      
      
      def verify_property_exists(name, data, prop, warnings)
        if (!data[prop])
          warnings << "#{name} missing #{prop}." 
        end
      end
      
      def verify_integer(name, data, prop, warnings)
        return if !data[prop]
        if (data[prop].class != Integer )
          warnings << "#{name}'s #{prop} should be a number."
        end
      end
      
      def verify_ability_range(name, data, prop, warnings)
        return if !data[prop]
        return if (data[prop].class != Integer )
        
        if (data[prop] > 4 || data[prop] < -4)
          warnings << "#{name}'s #{prop} seems high.  Ability mods are usually +/- 1 to 3."
        end
      end
      
      def verify_percentage(name, data, prop, warnings)
        return if !data[prop]
        return if (data[prop].class != Integer )
        
        if (data[prop] < 5 && data[prop] != 0 && data[prop] > -5)
          warnings << "#{name}'s #{prop} seems low.  It should be a percentage."
        end
      end
      
      def verify_action_skill(name, data, prop, warnings)
        skills = FS3Skills.action_skill_names
        if (!skills.include?(data[prop]))
          warnings << "#{name}'s #{prop} is not an action skill."
        end
      end
    end
  end
end