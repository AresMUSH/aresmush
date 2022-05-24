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
        item_spell_mod = Magic.item_spell_mod(target.associated_model)
        item_attack_mod = Magic.item_attack_mod(target.associated_model)
        item_init_mod = Magic.item_init_mod(target.associated_model)

        client.emit_success "#{target.name}'s modifications: GM_Init: #{target.init_mod} Item_Init: #{item_init_mod} GM_Spell: #{target.gm_spell_mod} Item_Spell: #{item_spell_mod} Spell: #{target.spell_mod} GM_Attack: #{target.attack_mod} Item_Attack: #{item_attack_mod} Spell_Attack: #{target.magic_attack_mod} Defense: #{target.defense_mod} Spell_Defense: #{target.magic_defense_mod} Lethality: #{target.damage_lethality_mod} Spell_Lethality: #{target.magic_lethal_mod}"
      end

    end
  end
end
