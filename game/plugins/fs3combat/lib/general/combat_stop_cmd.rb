module AresMUSH
  module FS3Combat
    class CombatStopCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :num
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("stop")
      end
      
      def crack!
        self.num = trim_input(cmd.args)
      end
      
      def check_number
        return t('fs3combat.invalid_combat_number') if !self.num.is_integer?
        return nil
      end
      
      def handle
        index = self.num.to_i - 1
        if (index < 0 || index > FS3Combat.combats.count)
          client.emit_failure t('fs3combat.invalid_combat_number')
          return
        end
        
        combat = FS3Combat.combats[index]
        combat.emit t('fs3combat.combat_stopped_by', :name => client.name)
        
        FS3Combat.combats.delete(combat)
        
        client.emit_success t('fs3combat.combat_stopped', :num => self.num)
      end
    end
  end
end