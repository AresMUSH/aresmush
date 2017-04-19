module AresMUSH
  module FS3Combat
    
    def self.combats
      Combat.all.sort { |c| c.num }.reverse
    end
    
    def self.combatant_types
      Global.read_config("fs3combat", "combatant_types")
    end
    
    def self.passenger_types
      [ "Pilot", "Passenger" ]
    end
    
    def self.is_in_combat?(name)
      !!FS3Combat.combat(name)
    end
    
    def self.combat(name)
      FS3Combat.combats.select { |c| c.has_combatant?(name) }.first
    end
    
    def self.combatant_type_stat(type, stat)
      type_config = FS3Combat.combatant_types[type]
      type_config[stat]
    end
    
    def self.npc_type(name)
      types = Global.read_config("fs3combat", "npc_types")
      types.select { |k, v| k.upcase == name.upcase}.values.first || {}
    end
    
    def self.npc_type_names
      Global.read_config("fs3combat", "npc_types").keys.map { |n| n.titlecase }
    end
    
    
    # Finds a character, vehicle or NPC by name
    def self.find_named_thing(name, enactor)
      result = ClassTargetFinder.find(name, Character, enactor)
      if (result.found?)
        return result.target
      end
      
      combatant = enactor.combatant
      if (!combatant)
        return nil
      end
      
      return combatant.combat.find_named_thing(name)
    end
    
    def self.get_initiative_order(combat)
      ability = Global.read_config("fs3combat", "initiative_skill")
      order = []
      combat.active_combatants.each do |c|
        roll = FS3Combat.roll_initiative(c, ability)
        order << { :combatant => c.id, :name => c.name, :roll => roll }
      end
      combat.log "Combat initiative rolls: #{order.map { |o| "#{o[:name]}=#{o[:roll]}" }}"
      order.sort_by { |c| c[:roll] }.map { |c| c[:combatant] }.reverse
    end
    
    def self.with_a_combatant(name, client, enactor, &block)      
      if (!enactor.is_in_combat?)
        client.emit_failure t('fs3combat.you_are_not_in_combat')
        return
      end
      
      combat = enactor.combat
      combatant = combat.find_combatant(name)
      
      if (!combatant)
        client.emit_failure t('fs3combat.not_in_combat', :name => name)
        return
      end
      
      yield combat, combatant
    end
    
    def self.npcmaster_text(name, actor)
      return nil if !actor
      actor.name == name ? nil : t('fs3combat.npcmaster_text', :name => actor.name)
    end
  end
end