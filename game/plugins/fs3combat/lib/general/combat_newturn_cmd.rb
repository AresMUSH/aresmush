module AresMUSH
  module FS3Combat
    class CombatNewTurnCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("newturn")
      end
      
      def handle
        if (!client.char.is_in_combat?)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
                
        combat = client.char.combatant.combat
        
        if (combat.organizer != client.char)
          client.emit_failure t('fs3combat.only_organizer_can_do')
          return
        end
                
        Global.logger.debug "****** NEW COMBAT TURN ******"

        initiative_order = combat.roll_initiative
        
        initiative_order.each do |c|
          next if !c.action
          next if c.is_noncombatant?
          
          messages = c.action.resolve
          messages.each do |m|
            Global.logger.debug "#{m}"
            combat.emit m
          end
             
          # Reset aim if they've done anything other than aiming. 
          # TODO - Better way of doing this.
          # TODO - Reset action if out of ammo.
          # TODO - Reset action if target no longer exists.
          if (c.is_aiming && c.action.class != AimAction)
            Global.logger.debug "Reset aim for #{c.name}."
            c.is_aiming = false
          end
          
          c.posed = false
          c.save
          
        end
        
        combat.emit t('fs3combat.new_turn', :name => client.name)
      end
    end
  end
end