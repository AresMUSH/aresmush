module AresMUSH
  module FS3Combat
    class CombatDismountCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name
      
      def parse_args
        if (cmd.args)
          self.name = titlecase_arg(cmd.args)
        else
          self.name = enactor.name
        end
      end

      def required_args
        [ self.name ]
      end      
      
      def check_mounts_allowed
        return t('fs3combat.mounts_disabled') if !FS3Combat.mounts_allowed?
        return nil
      end
      
      def handle
        FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|    
          if (combatant.mount_type)                
            combatant.update(mount_type: nil)
            FS3Combat.emit_to_combat combat, t('fs3combat.dismounted', :name => combatant.name)
          else
            client.emit_failure t('fs3combat.not_mounted')
          end
          
        end
      end
    end
  end
end