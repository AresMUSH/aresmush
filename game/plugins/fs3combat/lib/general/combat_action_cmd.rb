module AresMUSH
  module FS3Combat
    class CombatActionCmd
      include Plugin
      include PluginRequiresLogin
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :action_args, :action_klass
      
      def want_command?(client, cmd)
        return false if !cmd.root_is?("combat")
        self.action_klass = find_action_klass(cmd)
        return !self.action_klass.nil?
      end
      
      def crack!
        # Command arguments are cracked by the action class.
        result = self.action_klass.crack_helper(client, cmd)
        self.name = result[:name]
        self.action_args = result[:action_args]
      end
      
    
      def check_noncombatant
        return t('fs3combat.you_are_a_noncombatant') if (client.char.combatant.is_noncombatant? && self.name == client.name)
        return nil
      end

      def find_action_klass(cmd)
        if (cmd.switch_is?("attack"))
          AttackAction
        elsif (cmd.switch_is?("pass"))
          PassAction
        elsif (cmd.switch_is?("aim"))
          AimAction
        elsif (cmd.switch_is?("reload"))
          ReloadAction
        elsif (cmd.switch_is?("fullauto"))
          FullautoAction
        elsif (cmd.switch_is?("treat"))
          TreatAction
        else
          nil
        end
      end
      
      def handle
        FS3Combat.with_a_combatant(self.name, client) do |combat, combatant|
          begin
            if (combatant.action)
              combatant.action.destroy
            end
            action = self.action_klass.new(combatant:combatant)
            action.parse_args(self.action_args)
            error = action.error_check
            if (error)
              client.emit_failure error
              return
            end
            action.save
            combatant.save
            combat.emit "#{action.print_action}"
          rescue Exception => err
            Global.logger.debug("Combat action error error=#{err} backtrace=#{err.backtrace[0,10]}")
            client.emit_failure t('fs3combat.invalid_action_params', :error => err)
          end
        end
      end
    end
  end
end