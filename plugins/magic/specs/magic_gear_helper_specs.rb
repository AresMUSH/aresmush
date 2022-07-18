module AresMUSH
  module Magic
    describe Magic do
      before do
        @combatant = double
      end

      describe :magic_weapon_effects do
        before do
          allow(@combatant).to receive(:weapon) {"Knife"}
          allow(@combatant).to receive(:magic_weapon_effects) {{"Knife"=>{"Fire":75}}}
          allow(Global).to receive(:read_config).with("spells", "Spell", "rounds") {100}
          
        end
        
        subject do
          Magic.set_magic_weapon_effects(@combatant, "Spell")
        end

        context "when the effect is already present on the weapon" do
          it "resets the rounds" do
            # allow(Global).to receive(:read_config).with("spells", "Spell", "weapon_specials") {"Fire"}
            # expect(@combatant).to receive(:update).with(magic_weapon_effects: {"Knife"=>{"Fire":100}})
            # subject
          end
        end

        context "when the effect is new on the weapon" do
          it "adds the effect to the weapon" do
            allow(Global).to receive(:read_config).with("spells", "Spell", "weapon_specials") {"Ice"}
            expect(@combatant).to receive(:update).with(magic_weapon_effects: {"Knife"=>{:Fire=>75, "Ice"=>100}})
            subject
          end
        end

      end

      describe :magic_armor_effects do
        #I'm not sure anything actively uses this.
        before  do
          allow(@combatant).to receive(:armor) {"Tactical"}
          allow(@combatant).to receive(:magic_weapon_effects) {{"Knife"=>{"Fire":75}}}
          allow(Global).to receive(:read_config).with("spells", "Spell", "rounds") {100}
        end
      end

      describe :magic_weapon_specials do
        before do
          allow(@combatant).to receive(:magic_weapon_effects) {{}}
          allow(Magic).to receive(:magic_item_weapon_specials) 
        end

        subject do
          Magic.magic_weapon_specials(@combatant, "Knife")
        end

        context "when it has specials from an item" do
          before do 
            allow(Magic).to receive(:magic_item_weapon_specials) {["Ice"]}
          end
          context "when it has active magic_weapon_effects" do
            
            it "sets the item and spell specials" do
              allow(@combatant).to receive(:magic_weapon_effects) {{"Knife"=>{"Fire":75}}}
              expect(subject).to eq ["Ice", :Fire]
            end
          end

          it "sets the item specials" do
            expect(subject).to eq ["Ice"]          
          end
        end

        context "when it has active magic_weapon_effects" do
          it "sets the spell specials" do
            allow(@combatant).to receive(:magic_weapon_effects) {{"Knife"=>{"Fire":75, "Ice":100}}}
            expect(subject).to eq [:Fire, :Ice]          
          end
        end
        context "when it has no specials" do 
          it "returns an empty array" do
            expect(subject).to eq []
          end
        end
      end

      describe :set_magic_weapon do
        before do
          allow(Magic).to receive(:magic_weapon_specials) {[]}
          # allow(@combatant).to receive(:ammo) 
          allow(@combatant).to receive(:combat) { @combat }
          allow(@combatant).to receive(:name)
          allow(FS3Combat).to receive(:emit_to_combat) {}
          allow(FS3Combat).to receive(:npcmaster_text) { "npcmaster" }
          allow(@combatant).to receive(:update)
          allow(FS3Combat).to receive(:weapon_stat)
          allow(@combatant).to receive(:action=)
          allow(@combatant).to receive(:weapon)
          allow(@combatant).to receive(:weapon_specials)
          allow(@combatant).to receive(:prior_ammo) { nil }
          allow(@combatant).to receive(:weapon_name) { nil }
          stub_translate_for_testing
        end

        subject do
          Magic.set_magic_weapon(@enactor, @combatant, "Stone Fists")
        end

        it "should add magic specials if present" do
          allow(Magic).to receive(:magic_weapon_specials) {["Strength"]}
          expect(@combatant).to receive(:update).with(weapon_name: "Stone Fists")
          expect(@combatant).to receive(:update).with(weapon_specials: ["Strength"])
          subject
        end
        
        it "should reset ammo" do
          expect(FS3Combat).to receive(:weapon_stat).with("Stone Fists", "ammo") { 22 }
          expect(@combatant).to receive(:update).with(ammo: 22)
          subject
        end
        
        it "should emit to combat" do
          expect(FS3Combat).to receive(:emit_to_combat).with(@combat, "fs3combat.weapon_changed", "npcmaster")
          subject
        end
        
        it "should set ammo to previous used ammo if there is one" do
          expect(FS3Combat).to receive(:weapon_stat).with("Stone Fists", "ammo") { 22 }
          expect(@combatant).to receive(:prior_ammo) { { "Stone Fists" => 17 } }
          expect(@combatant).to receive(:update).with(ammo: 17)
          subject
        end

        it "should set ammo to max ammo if there isn't one" do
          expect(FS3Combat).to receive(:weapon_stat).with("Stone Fists", "ammo") { 22 }
          expect(@combatant).to receive(:prior_ammo) { { "Pistol" => 7 } }
          expect(@combatant).to receive(:update).with(ammo: 22)
          subject
        end
        
        it "should save their prior ammo" do
          expect(FS3Combat).to receive(:weapon_stat).with("Stone Fists", "ammo") { 22 }
          expect(@combatant).to receive(:weapon_name) { "Pistol" }.twice
          expect(@combatant).to receive(:ammo) { 7 }
          expect(@combatant).to receive(:prior_ammo) { { "KEW" => 77 } }
          expect(@combatant).to receive(:update).with(ammo: 22)
          expect(@combatant).to receive(:update).with(max_ammo: 22)
          expect(@combatant).to receive(:update).with(prior_ammo: { "KEW" => 77, "Pistol" => 7 })
          subject
        end
      end

      describe :magic_armor_specials do
        before do
          allow(@combatant).to receive(:magic_armor_effects) {{}}
          allow(Magic).to receive(:magic_item_armor_specials) 
        end

        subject do
          Magic.magic_armor_specials(@combatant, "Plate")
        end

        context "when it has specials from an item" do
          before do 
            allow(Magic).to receive(:magic_item_armor_specials) {["Ice"]}
          end
          context "when it has active magic_weapon_effects" do
            
            it "sets the item and spell specials" do
              allow(@combatant).to receive(:magic_armor_effects) {{"Plate"=>{"Fire":75}}}
              expect(subject).to eq ["Ice", :Fire]
            end
          end

          it "sets the item specials" do
            expect(subject).to eq ["Ice"]          
          end
        end

        context "when it has active magic_weapon_effects" do
          it "sets the spell specials" do
            allow(@combatant).to receive(:magic_armor_effects) {{"Plate"=>{"Fire":75, "Ice":100}}}
            expect(subject).to eq [:Fire, :Ice]          
          end
        end
        context "when it has no specials" do 
          it "returns an empty array" do
            expect(subject).to eq []
          end
        end
      end

    end
  end
end