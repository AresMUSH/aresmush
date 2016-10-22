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
          @combat.stub(:emit)
          FS3Combat.stub(:npcmaster_text) { "npcmaster" }
          @combatant.stub(:update)
          FS3Combat.stub(:weapon_stat)
          @combatant.stub(:action=)
          @combatant.stub(:weapon)
          @combatant.stub(:weapon_specials)
        end

        it "should pretty up the weapon and specials if set" do
          @combatant.should_receive(:update).with(weapon: "Rifle")
          @combatant.should_receive(:update).with(weapon_specials: ["S1", "S2"])
          FS3Combat.set_weapon(@enactor, @combatant, "rifle", [ "s1", "s2" ])
        end
        
        it "should reset ammo" do
          FS3Combat.should_receive(:weapon_stat).with("rifle", "ammo") { 22 }
          @combatant.should_receive(:update).with(ammo: 22)
          FS3Combat.set_weapon(@enactor, @combatant, "rifle", [ "s1", "s2" ])
        end
        
        it "should reset stats if nil" do
          @combatant.should_receive(:update).with(weapon: nil)
          @combatant.should_receive(:update).with(weapon_specials: nil)
          @combatant.should_receive(:update).with(ammo: nil)
          FS3Combat.set_weapon(@enactor, @combatant, nil, nil)
        end
        
        it "should reset their combat action" do
          @combatant.should_receive(:action=).with(nil)
          FS3Combat.set_weapon(@enactor, @combatant, nil, nil)
        end
        
        it "should emit to combat" do
          @combat.should_receive(:emit).with("fs3combat.weapon_changed", "npcmaster")
          FS3Combat.set_weapon(@enactor, @combatant, "rifle", [ "s1", "s2" ])
        end
      end
    end
  end
end