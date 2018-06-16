module AresMUSH
  module FS3Combat
    describe ExplodeAction do
      before do
        @combatant = double
        @combat = double

        allow(@combatant).to receive(:combat) { @combat }
        allow(@combatant).to receive(:weapon) { "Missile" }
        allow(FS3Combat).to receive(:check_ammo) { true }
        allow(FS3Combat).to receive(:update_ammo) { nil }
        allow(@combatant).to receive(:name) { "A" }
        allow(FS3Combat).to receive(:weapon_stat) { "" }
        allow(FS3Combat).to receive(:weapon_stat).with("Missile", "weapon_type") { "Explosive" }
        stub_translate_for_testing
      end
      
      describe :prepare do
        before do
          allow(@combat).to receive(:find_combatant) { @target }
          @target = double
          allow(@target).to receive(:name) { "Target" }
          allow(@target).to receive(:is_noncombatant?) { false }
        end
        
        
        it "should fail if too many targets" do
          @action = ExplodeAction.new(@combatant, "target1 target2 taget3 target4")
          expect(@action.prepare).to eq "fs3combat.too_many_targets"
        end
        
        it "should fail if not enough ammot" do
          expect(FS3Combat).to receive(:check_ammo).with(@combatant, 1) { false }
          @action = ExplodeAction.new(@combatant, "target")
          expect(@action.prepare).to eq "fs3combat.out_of_ammo"
        end

        it "should fail if trying to use a non-explosive weapon" do
          expect(FS3Combat).to receive(:weapon_stat).with("Missile", "weapon_type") { "Ranged" }
          @action = ExplodeAction.new(@combatant, "target")
          expect(@action.prepare).to eq "fs3combat.not_explosive_weapon"
        end

        it "should succeed" do
          @action = ExplodeAction.new(@combatant, "target1 target2")
          expect(@action.prepare).to be_nil
          expect(@action.targets).to eq [ @target, @target ]
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
          allow(@combatant).to receive(:ammo) { 10 }
          allow(@combat).to receive(:find_combatant).with("Target1") { @target1 }
          allow(@combat).to receive(:find_combatant).with("Target2") { @target2 }
          allow(@combat).to receive(:find_combatant).with("Target3") { @target3 }
          allow(FS3Combat).to receive(:attack_target) { ["resultx"] }
          allow(FS3Combat).to receive(:weapon_stat).with("Missile", "has_shrapnel") { false }
          
          # By seeding the kernel random number generator, the first three shrapnel rolls
          # will always be 0, 4, 2.
          Kernel.srand 1003
        end
          
        it "should attack with only explosives if no shrapnel" do
          @action = ExplodeAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result1"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target2) { ["result2"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target3) { ["result3"] }
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.explode_resolution_message", "result1", "result2", "result3" ]
        end
        
        it "should attack with explosives and shrapnel" do
          allow(FS3Combat).to receive(:weapon_stat).with("Missile", "has_shrapnel") { true }
          @action = ExplodeAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result1"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target2) { ["result2"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target3) { ["result3"] }
          expect(FS3Combat).to receive(:resolve_attack).with(nil, "A", @target2, "Shrapnel" ) { ["shrapnel1"] }
          expect(FS3Combat).to receive(:resolve_attack).with(nil, "A", @target2, "Shrapnel" ) { ["shrapnel2"] }
          expect(FS3Combat).to receive(:resolve_attack).with(nil, "A", @target2, "Shrapnel" ) { ["shrapnel3"] }
          expect(FS3Combat).to receive(:resolve_attack).with(nil, "A", @target2, "Shrapnel" ) { ["shrapnel4"] }
          expect(FS3Combat).to receive(:resolve_attack).with(nil, "A", @target3, "Shrapnel" ) { ["shrapnel5"] }
          expect(FS3Combat).to receive(:resolve_attack).with(nil, "A", @target3, "Shrapnel" ) { ["shrapnel6"] }
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.explode_resolution_message", "result1", "result2", "shrapnel1",
            "shrapnel2", "shrapnel3", "shrapnel4", "result3", "shrapnel5", "shrapnel6" ]
        end
        
        it "should update ammo" do
          @action = ExplodeAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          allow(@combatant).to receive(:attack_target) { "result" }
          expect(FS3Combat).to receive(:update_ammo).with(@combatant, 1)
          @action.resolve
        end
        
        it "should add an out of ammo message" do
          @action = ExplodeAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          expect(FS3Combat).to receive(:update_ammo).with(@combatant, 1) { "out of ammo" }
          resolutions = @action.resolve
          expect(resolutions[resolutions.count - 1]).to eq "out of ammo"
        end
      end
    end
  end
end
