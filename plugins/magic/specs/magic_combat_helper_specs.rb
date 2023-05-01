module AresMUSH
  module Magic
    describe Magic do
      before do
        @combatant = double
        allow(@combatant).to receive(:class) { Combatant }
        allow(@combatant).to receive(:name) { "CombatantName" }
        @char = double
        allow(@char).to receive(:name) { "CharName" }
        allow(@combatant).to receive(:associated_model) { @char }
        @npc = double
      end

      describe :get_associated_model do
        subject do
          Magic.get_associated_model(@combatant)
        end

        context 'when char_or_combatant is a combatant' do
          context 'when char_or_combatant is a character' do
            it 'returns the character' do
              expect(subject).to eq @char
            end
          end

          context 'when char_or_combatant is an NPC' do
            it 'returns the NPC' do
              allow(@combatant).to receive(:associated_model) { @npc }
              expect(subject).to eq @npc
            end
          end

        end

        context 'when char_or_combatant is a character' do
          it 'returns the character' do
            allow(@char).to receive(:class) { Character }
            expect(Magic.get_associated_model(@char)).to eq @char
          end
        end
      end

      describe :roll_combat_spell do
        before do
          allow(FS3Combat).to receive(:weapon_stat).with('Fireball', 'skill') { 'Fire' }
          allow(FS3Combat).to receive(:weapon_stat).with('Fireball', 'accuracy') { 0 }
          allow(@combatant).to receive(:total_damage_mod) { 0 }
          allow(@combatant).to receive(:attack_stance_mod) { 0 }
          allow(@combatant).to receive(:stress) { 0 }
          allow(@combatant).to receive(:attack_mod) { 0 }
          allow(@combatant).to receive(:is_aiming?) { false }
          allow(@combatant).to receive(:weapon) { 'Fireball' }
          allow(@combatant).to receive(:luck)
          @target = double
          allow(@target).to receive(:mount_type) { nil }
          allow(@combatant).to receive(:mount_type) { nil }
          allow(@combatant).to receive(:is_npc?) { false }
          allow(@combatant).to receive(:magic_attack_mod) { 0 }
          allow(@combatant).to receive(:gm_spell_mod) { 0 }
          allow(@combatant).to receive(:spell_mod) { 0 }
          allow(@combatant).to receive(:log)
          allow(@char).to receive(:magic_energy) {100}
          allow(@char).to receive(:total_magic_energy) {100}
          allow(@combatant).to receive(:magic_weapon_specials) {[]}

          @spell = double
          # allow(Global).to receive(:read_config).with("magic")
          allow(Magic).to receive(:spell_skill).with(@combatant, @spell) { { skill: 'Fire', cast_mod: 0 } }
          allow(Magic).to receive(:item_attack_mod) { 0 }
          allow(Magic).to receive(:item_spell_mod) { 0 }
          allow(Magic).to receive(:spell_level_mod).with(@spell) { 0 }
          allow(Magic).to receive(:spell_success)
        end

        it 'rolls the skill' do
          expect(@combatant).to receive(:roll_ability).with('Fire', 0)
          Magic.roll_combat_spell(@combatant, @spell)
        end

        context "when the spell is attack" do
          before do
            allow(Global).to receive(:read_config).with("spells", @spell, "fs3_attack") {true}
          end

          it 'accounts for magic attack modifiers' do
            allow(@combatant).to receive(:magic_attack_mod) { 2 }
            expect(@combatant).to receive(:roll_ability).with('Fire', 2)
            Magic.roll_combat_spell(@combatant, @spell)
          end

          it 'accounts for luck spent on attack' do
            allow(@combatant).to receive(:luck) { 'Attack' }
            expect(@combatant).to receive(:roll_ability).with('Fire', 3)
            Magic.roll_combat_spell(@combatant, @spell)
          end

          it 'accounts for item attack modifiers' do
            allow(Magic).to receive(:item_attack_mod) { 2 }
            expect(@combatant).to receive(:roll_ability).with('Fire', 2)
            Magic.roll_combat_spell(@combatant, @spell)
          end

        end

        context "when the spell is not an attack" do
          before do
            allow(Global).to receive(:read_config).with("spells", @spell, "fs3_attack") {nil}
          end

          it "does not apply magic attack modifiers" do
            allow(@combatant).to receive(:magic_attack_mod) { 2 }
            expect(@combatant).to receive(:roll_ability).with('Fire', 0)
            Magic.roll_combat_spell(@combatant, @spell)
          end

          it 'does not apply luck spent on attack' do
            allow(@combatant).to receive(:luck) { 'Attack' }
            expect(@combatant).to receive(:roll_ability).with('Fire', 0)
            Magic.roll_combat_spell(@combatant, @spell)
          end

          it 'does not apply item attack modifiers' do
            allow(Magic).to receive(:item_attack_mod) { 2 }
            expect(@combatant).to receive(:roll_ability).with('Fire', 0)
            Magic.roll_combat_spell(@combatant, @spell)
          end
        end

        it 'accounts for wound modifiers' do
          allow(@combatant).to receive(:total_damage_mod) { -1 }
          expect(@combatant).to receive(:roll_ability).with('Fire', -1)
          Magic.roll_combat_spell(@combatant, @spell)
        end

        it 'accounts for stance modifiers' do
          allow(@combatant).to receive(:attack_stance_mod) { 1 }
          expect(@combatant).to receive(:roll_ability).with('Fire', 1)
          Magic.roll_combat_spell(@combatant, @spell)
        end

        it 'accounts for accuracy modifiers' do
          allow(FS3Combat).to receive(:weapon_stat).with('Fireball', 'accuracy') { 2 }
          expect(@combatant).to receive(:roll_ability).with('Fire', 2)
          Magic.roll_combat_spell(@combatant, @spell)
        end

        it 'accounts for stress modifiers' do
          allow(@combatant).to receive(:stress) { 1 }
          expect(@combatant).to receive(:roll_ability).with('Fire', -1)
          Magic.roll_combat_spell(@combatant, @spell)
        end

        it 'accounts for spell level modifiers' do
          allow(Magic).to receive(:spell_level_mod).with(@spell) { -1 }
          expect(@combatant).to receive(:roll_ability).with('Fire', -1)
          Magic.roll_combat_spell(@combatant, @spell)
        end

        it 'accounts for gm-assigned spell modifiers' do
          allow(@combatant).to receive(:gm_spell_mod) { 1 }
          expect(@combatant).to receive(:roll_ability).with('Fire', 1)
          Magic.roll_combat_spell(@combatant, @spell)
        end

        it 'accounts for off school cast modifiers' do
          allow(Magic).to receive(:spell_skill).with(@combatant, @spell) { { skill: 'Fire', cast_mod: 3 } }
          expect(@combatant).to receive(:roll_ability).with('Fire', 3)
          Magic.roll_combat_spell(@combatant, @spell)
        end

        it 'accounts for magic spell modifiers' do
          allow(@combatant).to receive(:spell_mod) { 1 }
          expect(@combatant).to receive(:roll_ability).with('Fire', 1)
          Magic.roll_combat_spell(@combatant, @spell)
        end

        it 'accounts for item spell modifiers' do
          allow(Magic).to receive(:item_spell_mod) { 3 }
          expect(@combatant).to receive(:roll_ability).with('Fire', 3)
          Magic.roll_combat_spell(@combatant, @spell)
        end

        it 'accounts for luck spent on spells' do
          allow(@combatant).to receive(:luck) { 'Spell' }
          expect(@combatant).to receive(:roll_ability).with('Fire', 3)
          Magic.roll_combat_spell(@combatant, @spell)
        end

        it 'ignores luck spent on something else' do
          allow(@combatant).to receive(:luck) { 'Defense' }
          expect(@combatant).to receive(:roll_ability).with('Fire', 0)
          Magic.roll_combat_spell(@combatant, @spell)
        end

        it 'accounts for multiple modifiers' do
          allow(@combatant).to receive(:total_damage_mod) { -2 }
          allow(@combatant).to receive(:attack_stance_mod) { 1 }
          allow(@combatant).to receive(:luck) { 'Spell' }
          allow(Magic).to receive(:item_spell_mod) { 3 }
          allow(Magic).to receive(:spell_level_mod).with(@spell) { -1 }
          expect(@combatant).to receive(:roll_ability).with('Fire', 4)
          Magic.roll_combat_spell(@combatant, @spell)
        end
      end

      describe :spell_new_turn do
        before do
          allow(Magic).to receive(:shield_newturn_countdown)
          allow(Magic).to receive(:magic_auto_revive)
          allow(Magic).to receive(:stun_newturn)
          allow(Magic).to receive(:magic_attack_mod_newturn)
          allow(Magic).to receive(:magic_defense_mod_newturn)
          allow(Magic).to receive(:magic_lethal_mod_newturn)
          allow(Magic).to receive(:magic_init_mod_newturn)
          allow(Magic).to receive(:magic_spell_mod_newturn)
          allow(Magic).to receive(:magic_auto_revive)
          allow(@combatant).to receive(:magic_stun) {false}
          allow(@combatant).to receive(:magic_attack_mod) {0}
          allow(@combatant).to receive(:magic_defense_mod) {0}
          allow(@combatant).to receive(:magic_init_mod) {0}
          allow(@combatant).to receive(:magic_lethal_mod) {0}
          allow(@combatant).to receive(:spell_mod) {0}
          allow(@combatant).to receive(:is_npc?) {false}
          allow(@combatant).to receive(:is_ko) {false}
          allow(@combatant).to receive(:associated_model) {@char}
          allow(@char).to receive(:auto_revive?) {false}
          allow(@combatant).to receive(:log)
          allow(@combatant).to receive(:combat)
          @combat = double
          allow(@combatant).to receive(:combat) {@combat}
          allow(FS3Combat).to receive(:emit_to_combat) {}
        end

        subject do
          Magic.spell_new_turn(@combatant)
        end
        it "returns a msg when a stun wears off" do
          allow(@combatant).to receive(:magic_stun) {true}
          allow(Magic).to receive(:stun_newturn) {"Msg"}
          expect(FS3Combat).to receive(:emit_to_combat).with(@combat,"Msg", nil, true)
          Magic.spell_new_turn(@combatant)
        end

        it "returns a msg when a magic attack mod wears off" do
          allow(@combatant).to receive(:magic_attack_mod) {1}
          allow(Magic).to receive(:magic_attack_mod_newturn) {"mod"}
          expect(FS3Combat).to receive(:emit_to_combat).with(@combat,"CombatantName's %xgmod modification%xn %x11has worn off%xn.", nil, true)
          Magic.spell_new_turn(@combatant)
        end

        it "returns a msg when a magic defense mod wears off" do
          allow(@combatant).to receive(:magic_defense_mod) {1}
          allow(Magic).to receive(:magic_defense_mod_newturn) {"mod"}
          expect(FS3Combat).to receive(:emit_to_combat).with(@combat,"CombatantName's %xgmod modification%xn %x11has worn off%xn.", nil, true)
          Magic.spell_new_turn(@combatant)
        end

        it "returns a msg when a magic init mod wears off" do
          allow(@combatant).to receive(:magic_init_mod) {1}
          allow(Magic).to receive(:magic_init_mod_newturn) {"mod"}
          expect(FS3Combat).to receive(:emit_to_combat).with(@combat,"CombatantName's %xgmod modification%xn %x11has worn off%xn.", nil, true)
          Magic.spell_new_turn(@combatant)
        end

        it "returns a msg when a magic lethal mod wears off" do
          allow(@combatant).to receive(:magic_lethal_mod) {1}
          allow(Magic).to receive(:magic_lethal_mod_newturn) {"mod"}
          expect(FS3Combat).to receive(:emit_to_combat).with(@combat,"CombatantName's %xgmod modification%xn %x11has worn off%xn.", nil, true)
          Magic.spell_new_turn(@combatant)

        end

        it "returns a msg when a magic spell mod wears off" do
          allow(@combatant).to receive(:spell_mod) {1}
          allow(Magic).to receive(:magic_spell_mod_newturn) {"mod"}
          expect(FS3Combat).to receive(:emit_to_combat).with(@combat,"CombatantName's %xgmod modification%xn %x11has worn off%xn.", nil, true)
          Magic.spell_new_turn(@combatant)
        end

        it "returns a plural message if more than one mod wears off" do
          allow(@combatant).to receive(:spell_mod) {1}
          allow(Magic).to receive(:magic_spell_mod_newturn) {"spell"}
          allow(@combatant).to receive(:magic_lethal_mod) {1}
          allow(Magic).to receive(:magic_lethal_mod_newturn) {"lethality"}
          expect(FS3Combat).to receive(:emit_to_combat).with(@combat,"CombatantName's %xglethality, spell modifications%xn %x11have worn off%xn.", nil, true)
          Magic.spell_new_turn(@combatant)
        end

        it "returns a msg when a character is auto revived" do
          allow(@char).to receive(:auto_revive?) {true}
          allow(@combatant).to receive(:is_ko) {true}
          allow(Magic).to receive(:magic_auto_revive) {"Msg"}
          expect(FS3Combat).to receive(:emit_to_combat).with(@combat,"Msg", nil, true)
          Magic.spell_new_turn(@combatant)
        end

        it "should handle multiple messages" do
          allow(@char).to receive(:auto_revive?) {true}
          allow(@combatant).to receive(:is_ko) {true}
          allow(@combatant).to receive(:spell_mod) {1}
          allow(Magic).to receive(:magic_spell_mod_newturn) {"spell"}
          allow(@combatant).to receive(:magic_lethal_mod) {1}
          allow(Magic).to receive(:magic_lethal_mod_newturn) {"lethality"}
          allow(Magic).to receive(:magic_auto_revive) {"Msg"}
          expect(FS3Combat).to receive(:emit_to_combat).with(@combat,"Msg\nCombatantName's %xglethality, spell modifications%xn %x11have worn off%xn.", nil, true)
          Magic.spell_new_turn(@combatant)
        end
      end

      describe :stun_newturn do
        before do
          stub_translate_for_testing
        end

        subject do
          Magic.stun_newturn(@combatant)
        end

        context "when the counter is 0" do
          before do
            allow(@combatant).to receive(:magic_stun_counter) {0}
            allow(@combatant).to receive(:log)
            allow(@combatant).to receive(:update)
          end

          it "sets magic_stun to false and deletes the magic_stun_spell" do
            allow(@combatant).to receive(:log)
            expect(@combatant).to receive(:update).with(magic_stun: false)
            expect(@combatant).to receive(:update).with(magic_stun_spell: nil)
            subject
          end

          it "sends stun_wore_off msg" do
            expect(subject).to eq "magic.stun_wore_off"
          end
        end

        context "when the counter is > 0" do
          before do
            allow(@combatant).to receive(:magic_stun_counter) {2}
            allow(@combatant).to receive(:update)
            allow(@combatant).to receive(:subdued_by) {@char}
          end

          it "reduces the counter by 1" do
            expect(@combatant).to receive(:update).with(magic_stun_counter: 1)
            subject
          end

          it "sends still_stunned msg with the correct number of rounds" do
            expect(subject).to eq "magic.still_stunned"
          end
        end

      end

      describe :magic_attack_mod_newturn do
        before do
          allow(@combatant).to receive(:magic_attack_mod) {3}
          allow(@combatant).to receive(:log)
          allow(@combatant).to receive(:update)
        end

        subject do
          Magic.magic_attack_mod_newturn(@combatant)
        end

        context "when the counter is 0" do
          before do
            allow(@combatant).to receive(:magic_attack_mod_counter) {0}
          end
          it "sets the mod to 0" do
            expect(@combatant).to receive(:update).with({magic_attack_mod: 0})
            subject
          end

          it "returns the mod value and type" do
            expect(subject).to eq "3 attack"
          end
        end
        context "when the counter is > 0" do
          before do
            allow(@combatant).to receive(:magic_attack_mod_counter) {3}
          end

          it "reduces the counter by 1" do
            expect(@combatant).to receive(:update).with({magic_attack_mod_counter: 2})
            subject
          end
        end
      end

      describe :magic_defense_mod_newturn do
        before do
          allow(@combatant).to receive(:magic_defense_mod) {3}
          allow(@combatant).to receive(:log)
          allow(@combatant).to receive(:update)
        end

        subject do
          Magic.magic_defense_mod_newturn(@combatant)
        end

        context "when the counter is 0" do
          before do
            allow(@combatant).to receive(:magic_defense_mod_counter) {0}
          end
          it "sets the mod to 0" do
            expect(@combatant).to receive(:update).with({magic_defense_mod: 0})
            subject
          end

          it "returns the mod value and type" do
            expect(subject).to eq "3 defense"
          end
        end
        context "when the counter is > 0" do
          before do
            allow(@combatant).to receive(:magic_defense_mod_counter) {3}
          end

          it "reduces the counter by 1" do
            expect(@combatant).to receive(:update).with({magic_defense_mod_counter: 2})
            subject
          end
        end
      end

      describe :magic_init_mod_newturn do
        before do
          allow(@combatant).to receive(:magic_init_mod) {3}
          allow(@combatant).to receive(:log)
          allow(@combatant).to receive(:update)
        end

        subject do
          Magic.magic_init_mod_newturn(@combatant)
        end

        context "when the counter is 0" do
          before do
            allow(@combatant).to receive(:magic_init_mod_counter) {0}
          end
          it "sets the mod to 0" do
            expect(@combatant).to receive(:update).with({magic_init_mod: 0})
            subject
          end

          it "returns the mod value and type" do
            expect(subject).to eq "3 initiative"
          end
        end
        context "when the counter is > 0" do
          before do
            allow(@combatant).to receive(:magic_init_mod_counter) {3}
          end

          it "reduces the counter by 1" do
            expect(@combatant).to receive(:update).with({magic_init_mod_counter: 2})
            subject
          end
        end
      end

      describe :magic_lethal_mod_newturn do
        before do
          allow(@combatant).to receive(:magic_lethal_mod) {3}
          allow(@combatant).to receive(:log)
          allow(@combatant).to receive(:update)
        end

        subject do
          Magic.magic_lethal_mod_newturn(@combatant)
        end

        context "when the counter is 0" do
          before do
            allow(@combatant).to receive(:magic_lethal_mod_counter) {0}
          end
          it "sets the mod to 0" do
            expect(@combatant).to receive(:update).with({magic_lethal_mod: 0})
            subject
          end

          it "returns the mod value and type" do
            expect(subject).to eq "3 lethality"
          end
        end
        context "when the counter is > 0" do
          before do
            allow(@combatant).to receive(:magic_lethal_mod_counter) {3}
          end

          it "reduces the counter by 1" do
            expect(@combatant).to receive(:update).with({magic_lethal_mod_counter: 2})
            subject
          end
        end
      end

      describe :magic_spell_mod_newturn do
        before do
          allow(@combatant).to receive(:spell_mod) {3}
          allow(@combatant).to receive(:log)
          allow(@combatant).to receive(:update)
        end

        subject do
          Magic.magic_spell_mod_newturn(@combatant)
        end

        context "when the counter is 0" do
          before do
            allow(@combatant).to receive(:spell_mod_counter) {0}
          end
          it "sets the mod to 0" do
            expect(@combatant).to receive(:update).with({spell_mod: 0})
            subject
          end

          it "returns the mod value and type" do
            expect(subject).to eq "3 spell"
          end
        end
        context "when the counter is > 0" do
          before do
            allow(@combatant).to receive(:spell_mod_counter) {3}
          end

          it "reduces the counter by 1" do
            expect(@combatant).to receive(:update).with({spell_mod_counter: 2})
            subject
          end
        end
      end

      describe :magic_auto_revive do
        before do
          allow(@char).to receive(:auto_revive?) {"ReviveSpell"}
          allow(@combatant).to receive(:associated_model) {@char}
          allow(@combatant).to receive(:update)
        end
        subject do
          Magic.magic_auto_revive(@combatant)
        end
        it "sets a character's action to cast their auto revive spell" do
          expect(@combatant).to receive(:update).with({action_klass: "AresMUSH::FS3Combat::SpellAction"})
          expect(@combatant).to receive(:update).with({action_args: "ReviveSpell/CombatantName"})
          subject
        end
        it "returns spell_action_msg_long" do
          stub_translate_for_testing
          expect(subject).to eq 'magic.spell_action_msg_long'
        end
      end

    end
  end
end
