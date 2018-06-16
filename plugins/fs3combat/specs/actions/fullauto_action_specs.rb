module AresMUSH
  module FS3Combat
    describe FullautoAction do
      before do
        @combatant = double
        @combat = double

        allow(@combatant).to receive(:combat) { @combat }
        allow(@combatant).to receive(:weapon) { "Rifle" }
        allow(FS3Combat).to receive(:check_ammo) { true }
        allow(FS3Combat).to receive(:update_ammo) { nil }
        allow(@combatant).to receive(:name) { "A" }
        allow(FS3Combat).to receive(:weapon_stat) { "" }
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
          @action = FullautoAction.new(@combatant, "target1 target2 taget3 target4")
          expect(@action.prepare).to eq "fs3combat.too_many_targets"
        end
        
        it "should fail if not enough ammo for a burst" do
          expect(FS3Combat).to receive(:check_ammo).with(@combatant, 8) { false }
          @action = FullautoAction.new(@combatant, "target")
          expect(@action.prepare).to eq "fs3combat.not_enough_ammo_for_fullauto"
        end

        it "should fail if trying to burst with non-auto weapon" do
          expect(FS3Combat).to receive(:weapon_stat).with("Rifle", "is_automatic") { false }
          @action = FullautoAction.new(@combatant, "target")
          expect(@action.prepare).to eq "fs3combat.burst_fire_not_allowed"
        end

        it "should warn if using an explosive weapon" do
          expect(FS3Combat).to receive(:weapon_stat).with("Rifle", "weapon_type") { "Explosive" }
          @action = FullautoAction.new(@combatant, "target1 target2")
          expect(@action.prepare).to eq "fs3combat.use_explode_command"
        end

        it "should warn if using a suppressive weapon" do
          expect(FS3Combat).to receive(:weapon_stat).with("Rifle", "weapon_type") { "Suppressive" }
          @action = FullautoAction.new(@combatant, "target1 target2")
          expect(@action.prepare).to eq "fs3combat.use_suppress_command"
        end

        it "should succeed" do
          @action = FullautoAction.new(@combatant, "target1 target2")
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
        end
          
        it "should attack a single target with all the bullets" do
          @action = FullautoAction.new(@combatant, "target1")
          @action.prepare
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result1"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result2"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result3"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result4"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result5"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result6"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result7"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result8"] }
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.fires_fullauto", "result1", "result2", "result3", "result4",
            "result5", "result6", "result7", "result8" ]
        end
        
        it "should attack two targets with split bullets" do
          @action = FullautoAction.new(@combatant, "target1 target2")
          @action.prepare
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result1"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result2"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result3"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target2) { ["result4"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target2) { ["result5"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target2) { ["result6"] }
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.fires_fullauto", "result1", "result2", "result3", "result4",
            "result5", "result6" ]
        end
        
        it "should attack three targets with split bullets" do
          @action = FullautoAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target1) { ["result1"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target2) { ["result2"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target3) { ["result3"] }
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.fires_fullauto", "result1", "result2", "result3" ]
        end
        
        it "should update ammo" do
          @action = FullautoAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          allow(@combatant).to receive(:attack_target) { ["result"] }
          expect(FS3Combat).to receive(:update_ammo).with(@combatant, 8)
          @action.resolve
        end
        
        it "should add an out of ammo message" do
          @action = FullautoAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          expect(FS3Combat).to receive(:update_ammo).with(@combatant, 8) { "out of ammo" }
          resolutions = @action.resolve
          expect(resolutions[resolutions.count - 1]).to eq "out of ammo"
        end
      end
    end
  end
end
