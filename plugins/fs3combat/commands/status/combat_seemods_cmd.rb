module AresMUSH
  module FS3Combat
    class CombatSeeModsCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress

      attr_accessor :target, :combat

      def parse_args
        self.combat = enactor.combat
        self.target = combat.find_combatant(cmd.args)
      end

      def handle
        if (self.combat.organizer != enactor)
          client.emit_failure t('fs3combat.only_organizer_can_do')
          return
        end

        client.emit_success "#{target.name}'s modifications: GM_Spell: #{target.gm_spell_mod}  Spell: #{target.spell_mod} Attack: #{target.attack_mod} Spell_Attack: #{target.spell_attack_mod} Defense: #{target.defense_mod} Spell_Defense: #{target.spell_defense_mod} Lethality: #{target.damage_lethality_mod} Spell_Lethality: #{target.spell_damage_lethality_mod}"
      end

    end
  end
end
