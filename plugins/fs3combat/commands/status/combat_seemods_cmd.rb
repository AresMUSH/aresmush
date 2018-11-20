module AresMUSH
  module FS3Combat
    class CombatSeeModsCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress

      attr_accessor :target

      def parse_args
        self.target = Character.find_one_by_name(cmd.args)
      end

      def handle
        combat = enactor.combat
        if (combat.organizer != enactor)
          client.emit_failure t('fs3combat.only_organizer_can_do')
          return
        end

        client.emit_success "#{target.name}'s modifications: Spell: #{target.combatant.spell_mod} Attack: #{target.combatant.attack_mod} Defense: #{target.combatant.defense_mod} Lethality: #{target.combatant.damage_lethality_mod}"
      end

    end
  end
end
