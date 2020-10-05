module AresMUSH
  module FS3Combat
    class CombatSummaryTemplate < ErbTemplateRenderer

      attr_accessor :combat, :filter
      
      def initialize(combat, filter)
        @combat = combat
        @filter = filter
        super File.dirname(__FILE__) + "/summary.erb"
      end
      
      def combatants
        all_combatants = self.combat.active_combatants
        if (self.filter)
          return all_combatants.select { |c| c.name.downcase.start_with?(self.filter.downcase) }
        end
        all_combatants
      end
      
      def slack(c)
        acted = !c.action ? '%xh%xr**%xn' : '%xg++%xn'
        
        if (c.is_npc?)
          posed = '%xg--%xn'
        elsif (c.idle)
          posed = '%xx%xhxx%xn'
        elsif (c.posed)
          posed = '%xg++%xn'
        else
          last_posed = c.character.last_posed || "**"          
          posed = "%xh%xr#{last_posed}%xn"
        end
        "#{acted} / #{left(posed, 5)}   "
      end
      
      def skill(c)
        weapon_skill = FS3Combat.weapon_stat(c.weapon, "skill")
        if (c.is_npc?)
          rating = c.npc.ability_rating(weapon_skill)
        else
          rating = FS3Skills.dice_rolled(c.character, weapon_skill)          
        end
        rating
      end
      
      def vehicles
        combat.vehicles.sort_by(:name, :order => "ALPHA" ).map { |v| v.name }.join(" ")
      end
            
      def combat_mods(c)
        "A:#{c.attack_mod} D:#{c.defense_mod} L:#{c.damage_lethality_mod} I:#{c.initiative_mod}"
      end
      
      def format_damage(c)
        return "%xh%xr#{t('fs3combat.ko_status')}%xn" if c.is_ko
        "#{FS3Combat.print_damage(c.total_damage_mod)} (#{(0 - c.total_damage_mod).ceil})"
      end
      
      def format_weapon(c)
        weapon = "#{c.weapon}"
        
        if (c.max_ammo > 0)
          notes = " (#{c.ammo})"
        else
          notes = ""
        end
        
        "#{weapon}#{notes}"
      end
      
      def format_vehicle(c)
        if (c.vehicle)
          return c.vehicle.name
        elsif (c.mount_type)
          return c.mount_type
        else
          return ''
        end
      end
      
    end
  end
end