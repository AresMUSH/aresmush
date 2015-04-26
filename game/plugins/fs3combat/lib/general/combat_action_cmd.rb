module AresMUSH
  module FS3Combat
    class CombatActionCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :name, :action_args
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && 
        cmd.switch_is?("attack")
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

      # TODO: Check not KO'd
      
      def handle
        FS3Combat.with_a_combatant(self.name, client) do |combat, combatant|
          begin
            action = AttackAction.new(combatant, self.action_args)
            error = action.check_action
            if (error)
              client.emit_failure error
              return
            end
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