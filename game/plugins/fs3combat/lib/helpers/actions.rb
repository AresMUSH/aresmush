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
        if (combatant.action)
          combatant.action.delete
        end
        action = action_klass.new(combatant:combatant)
        action.parse_args(args)
        error = action.error_check
        if (error)
          client.emit_failure error
          return
        end
        action.save
        combatant.save
        combat.emit "#{action.print_action}", FS3Combat.npcmaster_text(combatant.name, enactor)
      rescue Exception => err
        Global.logger.debug("Combat action error error=#{err} backtrace=#{err.backtrace[0,10]}")
        client.emit_failure t('fs3combat.invalid_action_params', :error => err)
      end
    end
  end
end