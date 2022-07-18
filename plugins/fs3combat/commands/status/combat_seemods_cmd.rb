module AresMUSH
  module FS3Combat
    class CombatSeeModsCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress

      attr_accessor :target_name, :combat

      def parse_args
        self.target_name = cmd.args
      end

      def check_errors
        return "Use: combat/seemods <name>" if !cmd.args
        self.combat = enactor.combat
        return client.emit_failure t('fs3combat.only_organizer_can_do') if (combat.organizer != enactor)
      end

      def handle
        target = combat.find_combatant(self.target_name)       
        
        item_spell_mod = Magic.item_spell_mod(target.associated_model)
        item_attack_mod = Magic.item_attack_mod(target.associated_model)
        item_init_mod = Magic.item_init_mod(target.associated_model)

        client.emit_success "#{target.name}'s modifications: GM_Init: #{target.initiative_mod} Item_Init: #{item_init_mod} GM_Spell: #{target.gm_spell_mod} Item_Spell: #{item_spell_mod} Spell: #{target.spell_mod} GM_Attack: #{target.attack_mod} Item_Attack: #{item_attack_mod} Spell_Attack: #{target.magic_attack_mod} Defense: #{target.defense_mod} Spell_Defense: #{target.magic_defense_mod} Lethality: #{target.damage_lethality_mod} Spell_Lethality: #{target.magic_lethal_mod}"
      end

    end
  end
end
