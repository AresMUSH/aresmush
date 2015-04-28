module AresMUSH
  module FS3Combat
    class CombatActionCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :name, :action_args, :action_klass
      
      def want_command?(client, cmd)
        return false if !cmd.root_is?("combat")
        self.action_klass = find_action_klass(cmd)
        return !self.action_klass.nil?
      end
      
      def crack!
        if (cmd.args =~ /\=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = titleize_input(cmd.args.arg1)
          self.action_args = cmd.args.arg2
        else
          self.name = client.name
          self.action_args = cmd.args
        end
      end

      def find_action_klass(cmd)
        if (cmd.switch_is?("attack"))
          AttackAction
        elsif (cmd.switch_is?("pass"))
          PassAction
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