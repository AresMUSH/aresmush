module AresMUSH
  module FS3Combat
    describe SuppressAction do
      before do
        @combatant = double
        @combat = double

        allow(@combatant).to receive(:combat) { @combat }
        allow(@combatant).to receive(:weapon) { "Rifle" }
        allow(FS3Combat).to receive(:check_ammo) { true }
        allow(FS3Combat).to receive(:update_ammo) { nil }
        allow(@combatant).to receive(:name) { "A" }
        allow(FS3Combat).to receive(:weapon_stat) { "" }
        allow(@combatant).to receive(:is_npc?) { false }
        allow(@combatant).to receive(:associated_model) { double }
        allow(Achievements).to receive(:award_achievement) {}
        
        stub_translate_for_testing
      end
      
      describe :prepare do
        before do
          allow(@combat).to receive(:find_combatant) { @target }
          @target = double
          allow(@target).to receive(:name) { "Target" }
          allow(@target).to receive(:is_noncombatant?) { false }
        end
        
        
        it "should fail if too many targets for fullauto" do
          expect(FS3Combat).to receive(:weapon_stat).with("Rifle", "weapon_type") { "Ranged" }
          expect(FS3Combat).to receive(:weapon_stat).with("Rifle", "is_automatic") { true }
          @action = SuppressAction.new(@combatant, "target1 target2 taget3 target4")
          expect(@action.prepare).to eq "fs3combat.too_many_targets"
        end
        
        it "should fail if too many targets for explosives" do
          expect(FS3Combat).to receive(:weapon_stat).with("Rifle", "weapon_type") { "Explosive" }
          @action = SuppressAction.new(@combatant, "target1 target2 taget3 target4")
          expect(@action.prepare).to eq "fs3combat.too_many_targets"
        end

        it "should fail if too many targets for single shot" do
          expect(FS3Combat).to receive(:weapon_stat).with("Rifle", "is_automatic") { false }
          @action = SuppressAction.new(@combatant, "target1 target2")
          expect(@action.prepare).to eq "fs3combat.too_many_targets"
        end
        
        it "should fail if not enough ammo for a burst" do
          expect(FS3Combat).to receive(:check_ammo).with(@combatant, 8) { false }
          @action = SuppressAction.new(@combatant, "target1 target2")
          expect(@action.prepare).to eq "fs3combat.not_enough_ammo_for_fullauto"
        end

        it "should fail if tnot enough ammo for a single shot" do
          expect(FS3Combat).to receive(:check_ammo).with(@combatant, 1) { false }
          @action = SuppressAction.new(@combatant, "target")
          expect(@action.prepare).to eq "fs3combat.out_of_ammo"
        end

        it "should allow multiple targets for fullauto" do
          expect(FS3Combat).to receive(:weapon_stat).with("Rifle", "is_automatic") { true }
          @action = SuppressAction.new(@combatant, "target1 target2 target3")
          expect(@action.prepare).to be_nil
          expect(@action.targets).to eq [ @target, @target, @target ]
        end
        
        it "should allow multiple targets for explosive" do
          expect(FS3Combat).to receive(:weapon_stat).with("Rifle", "weapon_type") { "Explosive" }
          @action = SuppressAction.new(@combatant, "target1 target2 target3")
          expect(@action.prepare).to be_nil
          expect(@action.targets).to eq [ @target, @target, @target ]
        end
        
        it "should allow a single target" do
          @action = SuppressAction.new(@combatant, "target")
          expect(@action.prepare).to be_nil
          expect(@action.targets).to eq [ @target ]
        end
      end
      
      describe :resolve do
        before do
          @target1 = double
          @target2 = double
          @target3 = double
          allow(@target1).to receive(:name) { "T1" }
          allow(@target2).to receive(:name) { "T2" }
          allow(@target3).to receive(:name) { "T3" }
          allow(@target1).to receive(:is_noncombatant?) { false }
          allow(@target2).to receive(:is_noncombatant?) { false }
          allow(@target3).to receive(:is_noncombatant?) { false }

          allow(@combatant).to receive(:update)
          allow(@combatant).to receive(:log)
          allow(@combatant).to receive(:ammo) { 10 }
          allow(@combat).to receive(:find_combatant).with("Target1") { @target1 }
          allow(@combat).to receive(:find_combatant).with("Target2") { @target2 }
          allow(@combat).to receive(:find_combatant).with("Target3") { @target3 }
          allow(FS3Combat).to receive(:roll_attack) { 1 }
          allow(@target1).to receive(:roll_ability) { 2 }
          allow(@target2).to receive(:roll_ability) { 2 }
          allow(@target3).to receive(:roll_ability) { 2 }
          allow(Global).to receive(:read_config).with("fs3combat", "composure_skill") { "Composure" }
        end
          
        it "should suppress a single target successfully" do
          @action = SuppressAction.new(@combatant, "target1")
          @action.prepare
          expect(FS3Combat).to receive(:roll_attack).with(@combatant, @target1) { 2 }
          expect(@target1).to receive(:roll_ability).with("Composure") { 0 }
          expect(@target1).to receive(:add_stress).with(4)
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.suppress_successful_msg" ]
        end

        it "should suppress a single target unsuccessfully" do
          @action = SuppressAction.new(@combatant, "target1")
          @action.prepare
          expect(FS3Combat).to receive(:roll_attack).with(@combatant, @target1) { 0 }
          expect(@target1).to receive(:roll_ability).with("Composure") { 1 }
          expect(@target1).to_not receive(:add_stress)
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.suppress_failed_msg" ]
        end

        
        it "should suppress multiple targets with separate rolls" do
          @action = SuppressAction.new(@combatant, "target1 target2")
          @action.prepare
          expect(FS3Combat).to receive(:roll_attack).with(@combatant, @target1) { 2 }
          expect(FS3Combat).to receive(:roll_attack).with(@combatant, @target2) { 1 }
          expect(@target1).to receive(:roll_ability).with("Composure") { 0 }
          expect(@target2).to receive(:roll_ability).with("Composure") { 3 }
          expect(@target1).to receive(:add_stress).with(4)
          expect(@target2).to_not receive(:add_stress)
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.suppress_successful_msg", "fs3combat.suppress_failed_msg" ]
        end
        
        it "should update ammo for multiple targets" do
          @action = SuppressAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          allow(@combatant).to receive(:attack_target) { "result" }
          expect(FS3Combat).to receive(:update_ammo).with(@combatant, 8)
          @action.resolve
        end
        
        it "should update ammo for a single targets" do
          @action = SuppressAction.new(@combatant, "target1")
          @action.prepare
          allow(@combatant).to receive(:attack_target) { "result" }
          expect(FS3Combat).to receive(:update_ammo).with(@combatant, 1)
          @action.resolve
        end
        
        it "should add an out of ammo message" do
          @action = SuppressAction.new(@combatant, "target1")
          @action.prepare
          expect(FS3Combat).to receive(:update_ammo).with(@combatant, 1) { "out of ammo" }
          resolutions = @action.resolve
          expect(resolutions[resolutions.count - 1]).to eq "out of ammo"
        end
      end
    end
  end
end
