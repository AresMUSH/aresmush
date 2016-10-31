module AresMUSH
  module FS3Combat
    describe FullautoAction do
      before do
        @combatant = double
        @combat = double

        @combatant.stub(:combat) { @combat }
        @combatant.stub(:weapon) { "Rifle" }
        @combatant.stub(:ammo) { nil }
        @combatant.stub(:name) { "A" }
        FS3Combat.stub(:weapon_stat) { "" }
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
          @action = FullautoAction.new(@combatant, "target1 target2 taget3 target4")
          @action.prepare.should eq "fs3combat.too_many_targets"
        end
        
        it "should fail if out of ammo" do
          @combatant.stub(:ammo) { 0 }
          @action = FullautoAction.new(@combatant, "target")
          @action.prepare.should eq "fs3combat.out_of_ammo"
        end

        it "should fail if not enough ammo for a burst" do
          @combatant.stub(:ammo) { 1 }
          @action = FullautoAction.new(@combatant, "target")
          @action.prepare.should eq "fs3combat.not_enough_ammo_for_fullauto"
        end

        it "should fail if trying to burst with non-auto weapon" do
          FS3Combat.should_receive(:weapon_stat).with("Rifle", "is_automatic") { false }
          @action = FullautoAction.new(@combatant, "target")
          @action.prepare.should eq "fs3combat.burst_fire_not_allowed"
        end

        it "should warn if using an explosive weapon" do
          FS3Combat.should_receive(:weapon_stat).with("Rifle", "weapon_type") { "Explosive" }
          @action = FullautoAction.new(@combatant, "target1 target2")
          @action.prepare.should eq "fs3combat.use_explode_command"
        end

        it "should warn if using a suppressive weapon" do
          FS3Combat.should_receive(:weapon_stat).with("Rifle", "weapon_type") { "Suppressive" }
          @action = FullautoAction.new(@combatant, "target1 target2")
          @action.prepare.should eq "fs3combat.use_suppress_command"
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
          FS3Combat.stub(:attack_target) { "resultx" }
        end
          
        it "should attack a single target with all the bullets xxx" do
          @action = FullautoAction.new(@combatant, "target1")
          @action.prepare
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { "result1" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { "result2" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { "result3" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { "result4" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { "result5" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { "result6" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { "result7" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { "result8" }
          resolutions = @action.resolve
          resolutions.should eq [ "fs3combat.fires_fullauto", "result1", "result2", "result3", "result4",
            "result5", "result6", "result7", "result8" ]
        end
        
        it "should attack two targets with split bullets" do
          @action = FullautoAction.new(@combatant, "target1 target2")
          @action.prepare
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { "result1" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { "result2" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { "result3" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target2) { "result4" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target2) { "result5" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target2) { "result6" }
          resolutions = @action.resolve
          resolutions.should eq [ "fs3combat.fires_fullauto", "result1", "result2", "result3", "result4",
            "result5", "result6" ]
        end
        
        it "should attack three targets with split bullets" do
          @action = FullautoAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          FS3Combat.should_receive(:attack_target).with(@combatant, @target1) { "result1" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target2) { "result2" }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target3) { "result3" }
          resolutions = @action.resolve
          resolutions.should eq [ "fs3combat.fires_fullauto", "result1", "result2", "result3" ]
        end
        
        it "should update ammo" do
          @action = FullautoAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          @combatant.stub(:attack_target) { "result" }
          FS3Combat.should_receive(:update_ammo).with(@combatant, 8)
          @action.resolve
        end
        
        it "should add an out of ammo message" do
          @action = FullautoAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          FS3Combat.should_receive(:update_ammo).with(@combatant, 8) { "out of ammo" }
          resolutions = @action.resolve
          resolutions[resolutions.count - 1].should eq "out of ammo"
        end
      end
    end
  end
end