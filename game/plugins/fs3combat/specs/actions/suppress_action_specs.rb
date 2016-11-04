module AresMUSH
  module FS3Combat
    describe SuppressAction do
      before do
        @combatant = double
        @combat = double

        @combatant.stub(:combat) { @combat }
        @combatant.stub(:weapon) { "Rifle" }
        FS3Combat.stub(:check_ammo) { true }
        FS3Combat.stub(:update_ammo) { nil }
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
        
        
        it "should fail if too many targets for fullauto" do
          FS3Combat.should_receive(:weapon_stat).with("Rifle", "weapon_type") { "Ranged" }
          FS3Combat.should_receive(:weapon_stat).with("Rifle", "is_automatic") { true }
          @action = SuppressAction.new(@combatant, "target1 target2 taget3 target4")
          @action.prepare.should eq "fs3combat.too_many_targets"
        end
        
        it "should fail if too many targets for explosives" do
          FS3Combat.should_receive(:weapon_stat).with("Rifle", "weapon_type") { "Explosive" }
          @action = SuppressAction.new(@combatant, "target1 target2 taget3 target4")
          @action.prepare.should eq "fs3combat.too_many_targets"
        end

        it "should fail if too many targets for single shot" do
          FS3Combat.should_receive(:weapon_stat).with("Rifle", "is_automatic") { false }
          @action = SuppressAction.new(@combatant, "target1 target2")
          @action.prepare.should eq "fs3combat.too_many_targets"
        end
        
        it "should fail if not enough ammo for a burst" do
          FS3Combat.should_receive(:check_ammo).with(@combatant, 8) { false }
          @action = SuppressAction.new(@combatant, "target1 target2")
          @action.prepare.should eq "fs3combat.not_enough_ammo_for_fullauto"
        end

        it "should fail if tnot enough ammo for a single shot" do
          FS3Combat.should_receive(:check_ammo).with(@combatant, 1) { false }
          @action = SuppressAction.new(@combatant, "target")
          @action.prepare.should eq "fs3combat.out_of_ammo"
        end

        it "should allow multiple targets for fullauto" do
          FS3Combat.should_receive(:weapon_stat).with("Rifle", "is_automatic") { true }
          @action = SuppressAction.new(@combatant, "target1 target2 target3")
          @action.prepare.should be_nil
          @action.targets.should eq [ @target, @target, @target ]
        end
        
        it "should allow multiple targets for explosive" do
          FS3Combat.should_receive(:weapon_stat).with("Rifle", "weapon_type") { "Explosive" }
          @action = SuppressAction.new(@combatant, "target1 target2 target3")
          @action.prepare.should be_nil
          @action.targets.should eq [ @target, @target, @target ]
        end
        
        it "should allow a single target" do
          @action = SuppressAction.new(@combatant, "target")
          @action.prepare.should be_nil
          @action.targets.should eq [ @target ]
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
          @combatant.stub(:log)
          @combatant.stub(:ammo) { 10 }
          @combat.stub(:find_combatant).with("Target1") { @target1 }
          @combat.stub(:find_combatant).with("Target2") { @target2 }
          @combat.stub(:find_combatant).with("Target3") { @target3 }
          FS3Combat.stub(:roll_attack) { 1 }
          @target1.stub(:roll_ability) { 2 }
          @target2.stub(:roll_ability) { 2 }
          @target3.stub(:roll_ability) { 2 }
          Global.stub(:read_config).with("fs3combat", "composure_ability") { "Composure" }
        end
          
        it "should suppress a single target successfully" do
          @action = SuppressAction.new(@combatant, "target1")
          @action.prepare
          FS3Combat.should_receive(:roll_attack).with(@combatant) { 2 }
          @target1.should_receive(:roll_ability).with("Composure") { 0 }
          @target1.should_receive(:add_stress).with(4)
          resolutions = @action.resolve
          resolutions.should eq [ "fs3combat.suppress_successful_msg" ]
        end

        it "should suppress a single target unsuccessfully" do
          @action = SuppressAction.new(@combatant, "target1")
          @action.prepare
          FS3Combat.should_receive(:roll_attack).with(@combatant) { 0 }
          @target1.should_receive(:roll_ability).with("Composure") { 1 }
          @target1.should_not_receive(:add_stress)
          resolutions = @action.resolve
          resolutions.should eq [ "fs3combat.suppress_failed_msg" ]
        end

        
        it "should suppress multiple targets with separate rolls" do
          @action = SuppressAction.new(@combatant, "target1 target2")
          @action.prepare
          FS3Combat.should_receive(:roll_attack).with(@combatant) { 2 }
          FS3Combat.should_receive(:roll_attack).with(@combatant) { 1 }
          @target1.should_receive(:roll_ability).with("Composure") { 0 }
          @target2.should_receive(:roll_ability).with("Composure") { 3 }
          @target1.should_receive(:add_stress).with(4)
          @target2.should_not_receive(:add_stress)
          resolutions = @action.resolve
          resolutions.should eq [ "fs3combat.suppress_successful_msg", "fs3combat.suppress_failed_msg" ]
        end
        
        it "should update ammo for multiple targets" do
          @action = SuppressAction.new(@combatant, "target1 target2 target3")
          @action.prepare
          @combatant.stub(:attack_target) { "result" }
          FS3Combat.should_receive(:update_ammo).with(@combatant, 8)
          @action.resolve
        end
        
        it "should update ammo for a single targets" do
          @action = SuppressAction.new(@combatant, "target1")
          @action.prepare
          @combatant.stub(:attack_target) { "result" }
          FS3Combat.should_receive(:update_ammo).with(@combatant, 1)
          @action.resolve
        end
        
        it "should add an out of ammo message" do
          @action = SuppressAction.new(@combatant, "target1")
          @action.prepare
          FS3Combat.should_receive(:update_ammo).with(@combatant, 1) { "out of ammo" }
          resolutions = @action.resolve
          resolutions[resolutions.count - 1].should eq "out of ammo"
        end
      end
    end
  end
end