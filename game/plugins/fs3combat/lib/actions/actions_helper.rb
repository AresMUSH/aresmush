module AresMUSH
  module FS3Combat
    def self.find_action_klass(name)
      case name
      when "attack"
        AttackAction
      when "pass"
        PassAction
      when "aim"
        AimAction
      when "reload"
        ReloadAction
      when "fullauto"
        FullautoAction
      when "treat"
        TreatAction
      else
        nil
      end
    end
    
    def self.set_action(client, enactor, combat, combatant, action_klass, args)
      begin
        action = action_klass.new(combatant)
        action.parse_args(args)
        error = action.error_check
        if (error)
          client.emit_failure error
          return
        end
        combat.emit "#{action.print_action}", FS3Combat.npcmaster_text(combatant.name, enactor)
      rescue Exception => err
        Global.logger.debug("Combat action error error=#{err} backtrace=#{err.backtrace[0,10]}")
        client.emit_failure t('fs3combat.invalid_action_params', :error => err)
      end
    end
    
    def self.roll_initiative(combat)
      ability = Global.read_config("fs3combat", "initiative_ability")
      order = []
      combat.combatants.each do |c|
        roll = c.roll_initiative(ability)
        order << { :combatant => c, :roll => roll }
      end
      Global.logger.debug "Combat initiative rolls: #{order.map { |o| "#{o[:combatant].name}=#{o[:roll]}" }}"
      order.sort_by { |c| c[:roll] }.map { |c| c[:combatant] }
    end
    
    def self.ai_action(combat, client, combatant)
      if (combatant.ammo == 0)
        FS3Combat.set_action(client, nil, self, combatant, FS3Combat::ReloadAction, "")
        # TODO - Use suppress attack for suppress only weapon
      else
        target = active_combatants.select { |t| t.team != combatant.team }.shuffle.first
        if (target)
          FS3Combat.set_action(client, nil, self, combatant, FS3Combat::AttackAction, target.name)
        end
      end   
    end
  end
end