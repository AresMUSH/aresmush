module AresMUSH
  module FS3Combat
    describe ExplodeAction do
      before do
        @combatant = double
        @combat = double

        @combatant.stub(:combat) { @combat }
        @combatant.stub(:weapon) { "Missile" }
        FS3Combat.stub(:check_ammo) { true }
        FS3Combat.stub(:update_ammo) { nil }
        @combatant.stub(:name) { "A" }
        FS3Combat.stub(:weapon_stat) { "" }
        FS3Combat.stub(:weapon_stat).with("Missile", "weapon_type") { "Explosive" }
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :prepare do
        before do
          @combat.stub(:find_combatant) { @target }
          @target = double
          @target.stub(:name) { "Target" }
          @target.stub(:is_noncombatant?) { false }
        end
        
        
        it "should fail if too many targets" do
          @action = ExplodeAction.new(@combatant, "target1 target2 taget3 target4")
          @action.prepare.should eq "fs3combat.too_many_targets"
        end
        
        it "should fail if not enough ammot" do
          FS3Combat.should_receive(:check_ammo).with(@combatant, 1) { false }
          @action = ExplodeAction.new(@combatant, "target")
          @action.prepare.should eq "fs3combat.out_of_ammo"
        end

        it "should fail if trying to use a non-explosive weapon" do
          FS3Combat.should_receive(:weapon_stat).with("Missile", "weapon_type") { "Ranged" }
          @action = ExplodeAction.new(@combatant, "target")
          @action.prepare.should eq "fs3combat.not_explosive_weapon"
        end

        it "should succeed" do
          @action = ExplodeAction.new(@combatant, "target1 target2")
          @action.prepare.should be_nil
          @action.targets.should eq [ @target, @target ]
        end
      end
      
      describe :resolve do
        before do
          @target1 = double
          @target2 = double
          @target3 = double
          @target1.stub(:name) { "T1" }
          @target2.stub(:name) { "T2" }
          @target3.stub(:name) { "T3" }
          @target1.stub(:is_noncombatant?) { false }
          @target2.stub(:is_noncombatant?) { false }
          @target3.stub(:is_noncombatant?) { false }

          @combatant.stub(:update)
          @combatant.stub(:ammo) { 10 }
          @combat.stub(:find_combatant).with("Target1") { @target1 }
          @combat.stub(:find_combatant).with("Target2") { @target2 }
          @combat.stub(:find_combatant).with("Target3") { @target3 }
          FS3Combat.stub(:attack_target) { ["resultx"] }
          FS3Combat.stub(:weapon_stat).with("Missile", "has_shrapnel") { false }
          
          # By seeding the kernel random number generator, the first three shrapnel rolls
          # will always be 0, 4, 2.
          Kernel.srand 1003
        end
          
        it "should attack with only explosives if no shrapnel" do
          @action = ExplodeAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { ["result1"] }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target2) { ["result2"] }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target3) { ["result3"] }
          resolutions = @action.resolve
          resolutions.should eq [ "fs3combat.explode_resolution_message", "result1", "result2", "result3" ]
        end
        
        it "should attack with explosives and shrapnel" do
          FS3Combat.stub(:weapon_stat).with("Missile", "has_shrapnel") { true }
          @action = ExplodeAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { ["result1"] }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target2) { ["result2"] }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target3) { ["result3"] }
          FS3Combat.should_receive(:resolve_attack).with(nil, "A", @target2, "Shrapnel" ) { ["shrapnel1"] }
          FS3Combat.should_receive(:resolve_attack).with(nil, "A", @target2, "Shrapnel" ) { ["shrapnel2"] }
          FS3Combat.should_receive(:resolve_attack).with(nil, "A", @target2, "Shrapnel" ) { ["shrapnel3"] }
          FS3Combat.should_receive(:resolve_attack).with(nil, "A", @target2, "Shrapnel" ) { ["shrapnel4"] }
          FS3Combat.should_receive(:resolve_attack).with(nil, "A", @target3, "Shrapnel" ) { ["shrapnel5"] }
          FS3Combat.should_receive(:resolve_attack).with(nil, "A", @target3, "Shrapnel" ) { ["shrapnel6"] }
          resolutions = @action.resolve
          resolutions.should eq [ "fs3combat.explode_resolution_message", "result1", "result2", "shrapnel1",
            "shrapnel2", "shrapnel3", "shrapnel4", "result3", "shrapnel5", "shrapnel6" ]
        end
        
        it "should update ammo" do
          @action = ExplodeAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          @combatant.stub(:attack_target) { "result" }
          FS3Combat.should_receive(:update_ammo).with(@combatant, 1)
          @action.resolve
        end
        
        it "should add an out of ammo message" do
          @action = ExplodeAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          FS3Combat.should_receive(:update_ammo).with(@combatant, 1) { "out of ammo" }
          resolutions = @action.resolve
          resolutions[resolutions.count - 1].should eq "out of ammo"
        end
      end
    end
  end
end