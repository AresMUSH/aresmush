module AresMUSH
  module Magic
    describe Magic do

      before do
        @char = double
        @allshield = double
        allow(@allshield).to receive(:name) {"Allshield"}
        allow(@allshield).to receive(:strength) {4}
        allow(@allshield).to receive(:shields_against) {"All"}
        allow(@char).to receive(:magic_shields) {[@allshield] }   
      end


      describe :find_shield_named do
        it "finds a shield by name" do
          expect(Magic.find_shield_named(@char, "Allshield")).to eq @allshield
        end
      end

      describe :find_best_shield do
        before do
          allow(Global).to receive(:read_config).with("magic", "shields_against_all_exceptions") { "Psionic"}
          @psionicshield = double
          allow(@psionicshield).to receive(:name) {"PsionicShield"}
          allow(@psionicshield).to receive(:shields_against) {"Psionic"}
          allow(@psionicshield).to receive(:strength) {3}          
          allow(@char).to receive(:magic_shields) {[@allshield, @psionicshield] }
        end

        context "when no shield protects against the damage type" do
          it "returns false" do
            allow(@allshield).to receive(:shields_against) {"Fire"}
            expect(Magic.find_best_shield(@char, "Water")).to eq false
          end
        end
              
        context "when the damage type is an exception to shields that protect against all" do

          subject do 
            Magic.find_best_shield(@char, "Psionic")
          end

          it "returns the best shield that protects against its exact damage type" do
            expect(subject).to eq @psionicshield
          end

        end

        context "when the damage type is not an exception to shields that protect against all" do
          subject do
            Magic.find_best_shield(@char, "Fire")
          end

          before do
            @fireshield = double
            allow(@fireshield).to receive(:name) {"FireShield"}
            allow(@fireshield).to receive(:strength) {2}
            allow(@fireshield).to receive(:shields_against) {"Fire"}

            @fireshield2 = double
            allow(@fireshield2).to receive(:name) {"FireShield2"}
            allow(@fireshield2).to receive(:strength) {2}
            allow(@fireshield2).to receive(:shields_against) {"Fire"}

            @allshield2 = double
            allow(@allshield2).to receive(:name) {"AllShield2"}
            allow(@allshield2).to receive(:strength) {2}
            allow(@allshield2).to receive(:shields_against) {"All"}

            allow(@psionicshield).to receive(:strength) {6}

            allow(@char).to receive(:magic_shields) {[@allshield, @allshield2, @psionicshield, @fireshield, @fireshield2]}          
          end

          context "and the strongest shield protects against all damage types" do
            it "returns the best shield that protects against all damage types" do 
              expect(subject).to eq @allshield
            end
          end

          context "and the strongest shield protects against its exact damage type" do
            it "returns the best shield that protects against its exact damage type" do
              allow(@fireshield).to receive(:strength) {5}
              expect(subject).to eq @fireshield
            end
          end
        end
      end

      describe :shield_newturn_countdown do
        before do
          @combatant = double
          allow(@combatant).to receive(:associated_model) {@char}
          allow(FS3Combat).to receive(:emit_to_combat) {}
        end

        subject do
          Magic.shield_newturn_countdown(@combatant)
        end
        
        context "when there are no rounds left" do
          it "deletes the shield" do
            allow(@allshield).to receive(:rounds) {0}
            allow(@combatant).to receive(:combat) {1}
            allow(@combatant).to receive(:name) {"Combatant"}
            expect(@allshield).to receive(:delete)
            Magic.shield_newturn_countdown(@combatant)
          end
        end

        context "when there are rounds left" do
          it "reduces the number of rounds left by 1" do
            allow(@allshield).to receive(:rounds) {5}
            expect(@allshield).to receive(:update).with(rounds: 4)
            Magic.shield_newturn_countdown(@combatant)
          end
        end        
      end

      describe :determine_margin_with_shield do
        before do
          @combatant = double
          allow(@combatant).to receive(:name) {"Combatant"}
          allow(@combatant).to receive(:weapon) {"Weapon"}
          @target = double
          @spell = double
          allow(Magic).to receive(:stopped_by_shield?) {{msg: "Shield won", shield: "Shield", hit: true}}
        end

        context "when the attack is stopped by a shield" do

          context "when the spell is a stun" do
            before do
              allow(Global).to receive(:read_config).with("spells", @spell, "is_stun") {true}
              # allow(FS3Combat).to receive(weapon_stat).with(weapon_or_spell, "is_stun") {false}
            end
            it "determines whether the stun was successful" do
              expect(Magic.determine_margin_with_shield(@target, @combatant, @spell, 4, 2)[:hit]).to eq true
              expect(Magic.determine_margin_with_shield(@target, @combatant, @spell, 2, 4)[:hit]).to eq false
            end
          end

          context "when the weapon is a stun" do
            before do
              allow(Global).to receive(:read_config).with("spells", @spell, "is_stun") {false}
              allow(FS3Combat).to receive(:weapon_stat).with(@spell, "is_stun") {true}
            end
            it "determines whether the stun was successful" do
              expect(Magic.determine_margin_with_shield(@target, @combatant, @spell, 4, 2)[:hit]).to eq true
              expect(Magic.determine_margin_with_shield(@target, @combatant, @spell, 2, 4)[:hit]).to eq false
            end
          end

          context "when the attack is not a stun" do
            before do
              allow(Global).to receive(:read_config).with("spells", @spell, "is_stun") {false}
              allow(FS3Combat).to receive(:weapon_stat).with(@spell, "is_stun") {false}
              allow(Magic).to receive(:stopped_by_shield?) {{msg: "Shield lost", shield: "Shield", hit: false}}
            end
            it "sets hit to false" do
              expect(Magic.determine_margin_with_shield(@target, @combatant, @spell, 4, 2)[:hit]).to eq false
            end
          end
        end

        context "when the attack is not stopped by a shield" do
          before do
            allow(Magic).to receive(:stopped_by_shield?) {{msg: "Shield won", shield: "Shield", hit: true}}
            allow(FS3Combat).to receive(:weapon_stat).with(@spell, "is_stun") {false}
          end
          it "sets hit to true" do
            expect(Magic.determine_margin_with_shield(@target, @combatant, @spell, 4, 2)[:hit]).to eq true
            # Magic.determine_margin_with_shield(@target, @combatant, @spell, 4, 2)
          end
        end
      end

      describe :stopped_by_shield? do
        before do
          allow(Magic).to receive(:get_associated_model).with(@char) {@char}
          allow(Magic).to receive(:magic_damage_type) {"Fire"}
          allow(Magic).to receive(:find_best_shield) {@allshield}
          allow(FS3Combat).to receive(:weapon_stat) {"Skill"}
          allow(@char).to receive(:name) {"Name"}
        end

        subject do
          Magic.stopped_by_shield?(@char,"Caster_Name", "Spell", 3)
        end
      
        context "when no shield protects against the damage type" do
          it "returns nothing" do
            allow(Magic).to receive(:find_best_shield) {nil}
            expect(subject).to eq nil
          end
        end

        context "when a shield protects against the damage type" do
          context "when the attacker's roll is greater than the shield's strength" do
            it "allows the attacker to hit" do
              allow(@allshield).to receive(:strength) {2}
              expect(subject[:shield]).to eq "Allshield"      
              expect(subject[:hit]).to eq true
            end
          end
          context "when the attacker's roll is less than the shield's strength" do            
            it "does not allow the attacker to hit" do
              expect(subject[:shield]).to eq "Allshield"      
              expect(subject[:hit]).to eq false
            end
          end

          context "when the attacker's roll is equal to the shield's strength" do
            it "does not allow the attacker to hit " do
              allow(@allshield).to receive(:strength) {3}
              expect(subject[:shield]).to eq "Allshield"      
              expect(subject[:hit]).to eq false
            end
          end

        end
      end

      describe :shield_success_msgs do
        before do
          allow(@char).to receive(:name) {"Target"}
          stub_translate_for_testing
        end
        
        context "when a shield holds against a weapon attack" do
          it "returns a held against attack msg" do  
            allow(Magic).to receive(:is_spell?) {false}   
            expect(Magic.shield_success_msgs(@char, "Name", "Weapon", "Shield")).to eq "magic.shield_held_against_attack"      
          end

          context "when the weapon is equipped via a spell" do              
            it "returns a held against attack msg" do
              allow(Magic).to receive(:is_spell?) {true}
              allow(Global).to receive(:read_config).with("spells", "Weapon", "fs3_attack") {false}
              expect(Magic.shield_success_msgs(@char, "Name", "Weapon", "Shield")).to eq "magic.shield_held_against_attack"
            end
          end
        
        end

        context "when a shield holds against a spell" do
          it "returns a held against spell msg" do
            allow(Magic).to receive(:is_spell?) {true}
            allow(Global).to receive(:read_config).with("spells", "Spell", "fs3_attack") {true}
            expect(Magic.shield_success_msgs(@char, "Name", "Spell", "Shield")).to eq "magic.shield_held_against_spell"
          end
        end
      end

      describe :shield_failed_msgs do
        before do
          @weapon_or_spell = "Spell"
          allow(@char).to receive(:name) {"TargetName"}
          allow(Magic).to receive(:magic_damage_type) {"Damage"}
          allow(Global).to receive(:read_config).with("magic",  "type_does_damage", "Damage") {true}
          allow(Global).to receive(:read_config).with("spells", @weapon_or_spell, "is_stun") {false}
          allow(FS3Combat).to receive(:weapon_stat).with(@weapon_or_spell, "is_stun") {false}
          allow(Magic).to receive(:find_best_shield) {@allshield}
          stub_translate_for_testing
          allow(Magic).to receive(:is_spell?) {true}
        end

        subject do 
          Magic.shield_failed_msgs(@char, "Name", @weapon_or_spell)
        end

        context "when a shield fails against shrapnel" do
          it "returns the shield_failed_against_shrapnel msg" do
            @weapon_or_spell = "Shrapnel"
            allow(Global).to receive(:read_config).with("spells", @weapon_or_spell, "is_stun") {false}
            allow(FS3Combat).to receive(:weapon_stat).with(@weapon_or_spell, "is_stun") {false}
            expect(subject).to eq "magic.shield_failed_against_shrapnel"
          end
        end

        context "when a shield fails against a weapon" do
          it "returns the shield_failed_against_attack msg" do
            allow(Magic).to receive(:is_spell?) {false}
            expect(subject).to eq "magic.shield_failed_against_attack"
          end
        end

        context "when a shield fails against a spell that does damage" do
          it "returns the shield_failed_against_spell msg" do
            expect(subject).to eq "magic.shield_failed_against_spell"
          end
        end

        context "when a shield fails against a spell that doesn't do damage" do
          it "returns the no_damage_shield_failed msg" do
            allow(Global).to receive(:read_config).with("magic",  "type_does_damage", "Damage") {false}
            expect(subject).to eq "magic.no_damage_shield_failed"
          end
        end

        context "when a shield fails against stun" do
          before do
            allow(Global).to receive(:read_config).with("magic",  "type_does_damage", "Damage") {false}
          end

          context "when the weapon is a stun" do
            it "returns the shield_failed_stun msg" do
              allow(Global).to receive(:read_config).with("spells", @weapon_or_spell, "rounds") {0}
              allow(FS3Combat).to receive(:weapon_stat).with(@weapon_or_spell, "is_stun") {true}
              expect(subject).to eq "magic.shield_failed_stun"
            end
          end
          context "when the spell is a stun" do
            it "returns the shield_failed_stun msg" do
              allow(Global).to receive(:read_config).with("spells", @weapon_or_spell, "rounds") {0}
              allow(Global).to receive(:read_config).with("spells", @weapon_or_spell, "is_stun") {true}
              expect(subject).to eq "magic.shield_failed_stun"
            end
          end
        end
         
      end


      describe :shield_mods do
        it "returns the base shield defense + the shield strength multiplier" do
          allow(Global).to receive(:read_config).with("magic", "shield_base_defense") {10}
          allow(Global).to receive(:read_config).with("magic", "shield_strength_multiplier") {2}
          allow(Magic).to receive(:find_best_shield) {@allshield}
          allow(@char).to receive(:log) 
          expect(Magic.shield_mods(@char, "Damage")).to eq -18
        end
      end


    end
  end

end