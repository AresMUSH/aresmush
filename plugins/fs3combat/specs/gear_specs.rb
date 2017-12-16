module AresMUSH
  module FS3Combat
    describe FS3Combat do
      before do
        @combat = double
        @enactor = double
        @client = double
        @combatant = double
        
        @combatant.stub(:name) { "Trooper" }
        
        SpecHelpers.stub_translate_for_testing
      end

      describe :armor_stat do
        before do 
          specials = {
            "Helmet" => { "defense" => 2, "protection" => { "Head" => 2 } },
            "Cup" => { "protection" => { "Groin" => 2 } } }
          FS3Combat.stub(:armor_specials) { specials }
          FS3Combat.stub(:armor).with("Military") { { "defense" => 1, "protection" => { "Head" => 1, "Body" => 4 } } }
        end
        
        it "should return nil if armor not found" do
          FS3Combat.stub(:armor).with("Police") { nil }
          FS3Combat.armor_stat("Police", "protection").should be_nil
        end
        
        it "should add special protection together" do
          protection = FS3Combat.armor_stat("Military+Helmet+Cup", "protection")
          protection['Head'].should eq 3
          protection['Body'].should eq 4
          protection['Groin'].should eq 2
        end
        
        it "should add other stats" do
          defense = FS3Combat.armor_stat("Military+Helmet", "defense")
          defense.should eq 3
        end
        
        it "should not add anything if no special stat exists" do
          defense = FS3Combat.armor_stat("Military+Cup", "defense")
          defense.should eq 1
        end
        
        
      end      
      
      describe :weapon_stat do
        before do
          FS3Combat.stub(:weapon).with("Rifle") { { "penetration" => 3, "lethality" => 10 } }
          specials = {
            "Ap" => { "penetration" => 2 },
            "Silencer" => { "lethality" => -5 }
          }
          FS3Combat.stub(:weapon_specials) { specials }
        end
        
        it "should return nil if weapon not found" do
           FS3Combat.stub(:weapon) { nil }
           FS3Combat.weapon_stat("Banjo", "penetration").should be_nil
        end

        it "should return nil if weapon has no stat" do
           FS3Combat.weapon_stat("Rifle", "moxie").should be_nil
        end
        
        it "should return a value for a weapon without a special" do
          FS3Combat.weapon_stat("Rifle", "penetration").should eq 3
        end

        it "should return raw value for a weapon with an invalid special" do
          FS3Combat.weapon_stat("Rifle+Foo", "penetration").should eq 3
        end
        
        it "should adjust a value for a weapon with a special" do
          FS3Combat.weapon_stat("Rifle+Ap", "penetration").should eq 5
        end
        
        it "should handle multiple specials" do
          FS3Combat.weapon_stat("Rifle+Ap+Silencer", "penetration").should eq 5
        end
      end
      
      describe :set_default_gear do
        before do
          FS3Combat.stub(:combatant_type_stat) { nil }
          FS3Combat.stub(:combatant_type_stat) { nil }
        end
        
        it "should set a weapon if set" do
          FS3Combat.should_receive(:combatant_type_stat).with("soldier", "weapon") { "rifle" }
          FS3Combat.should_receive(:combatant_type_stat).with("soldier", "weapon_specials") { "specials" }
          FS3Combat.should_receive(:set_weapon).with(@enactor, @combatant, "rifle", "specials")
          FS3Combat.set_default_gear(@enactor, @combatant, "soldier")
        end
        
        it "should not set a weapon if none set" do
          FS3Combat.should_not_receive(:set_weapon)
          FS3Combat.set_default_gear(@enactor, @combatant, "soldier")
        end

        it "should set armor if set" do
          FS3Combat.should_receive(:combatant_type_stat).with("soldier", "armor") { "kevlar" }
          FS3Combat.should_receive(:set_armor).with(@enactor, @combatant, "kevlar")
          FS3Combat.set_default_gear(@enactor, @combatant, "soldier")
        end
        
        it "should not set armor if none set" do
          FS3Combat.should_not_receive(:set_armor)
          FS3Combat.set_default_gear(@enactor, @combatant, "soldier")
        end

      end
      
      describe :set_weapon do
        before do
          @combatant.stub(:combat) { @combat }
          FS3Combat.stub(:emit_to_combat) {}
          FS3Combat.stub(:npcmaster_text) { "npcmaster" }
          @combatant.stub(:update)
          FS3Combat.stub(:weapon_stat)
          @combatant.stub(:action=)
          @combatant.stub(:weapon)
          @combatant.stub(:weapon_specials)
        end

        it "should pretty up the weapon and specials if set" do
          @combatant.should_receive(:update).with(weapon_name: "Rifle")
          @combatant.should_receive(:update).with(weapon_specials: ["S1", "S2"])
          FS3Combat.set_weapon(@enactor, @combatant, "rifle", [ "s1", "s2" ])
        end
        
        it "should reset ammo" do
          FS3Combat.should_receive(:weapon_stat).with("rifle", "ammo") { 22 }
          @combatant.should_receive(:update).with(ammo: 22)
          FS3Combat.set_weapon(@enactor, @combatant, "rifle", [ "s1", "s2" ])
        end
        
        it "should reset stats if nil" do
          @combatant.should_receive(:update).with(weapon_name: "Unarmed")
          @combatant.should_receive(:update).with(weapon_specials: [])
          @combatant.should_receive(:update).with(ammo: 0)
          @combatant.should_receive(:update).with(max_ammo: 0)
          FS3Combat.set_weapon(@enactor, @combatant, nil, nil)
        end
        
        it "should reset their combat action" do
          @combatant.should_receive(:update).with(action_klass: nil)
          @combatant.should_receive(:update).with(action_args: nil)
          FS3Combat.set_weapon(@enactor, @combatant, nil, nil)
        end
        
        it "should emit to combat" do
          FS3Combat.should_receive(:emit_to_combat).with(@combat, "fs3combat.weapon_changed", "npcmaster")
          FS3Combat.set_weapon(@enactor, @combatant, "rifle", [ "s1", "s2" ])
        end
      end
    end
  end
end