module AresMUSH
  module FS3Combat
    describe AttackAction do
      before do
        @combatant = double
        @target = double
        @combat = double

        @combat.stub(:find_combatant) { @target }
        @combatant.stub(:combat) { @combat }
        @combatant.stub(:weapon) { "Rifle" }
        @combatant.stub(:name) { "A" }
        FS3Combat.stub(:hitloc_areas) { [] }
        @target.stub(:name) { "Target" }
        @target.stub(:is_noncombatant?) { false }
        FS3Combat.stub(:weapon_stat) { "" }
        FS3Combat.stub(:check_ammo) { true }
        FS3Combat.stub(:update_ammo) { nil }
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :prepare do
        it "should parse simple taget" do
          @action = AttackAction.new(@combatant, " target ")
          @action.prepare.should be_nil
          @action.is_burst.should be_false
          @action.called_shot.should be_nil
          @action.crew_hit.should eq false
          @action.mod.should eq 0
        end
        
        it "should parse target plus mod" do
          @action = AttackAction.new(@combatant, "target/mod:3")
          @action.prepare.should be_nil
          @action.is_burst.should be_false
          @action.called_shot.should be_nil
          @action.crew_hit.should eq false
          @action.mod.should eq 3
        end
        
        it "should parse target plus called" do
          @action = AttackAction.new(@combatant, "target/called:head")
          FS3Combat.stub(:hitloc_areas) { ["Head"] }
          @action.prepare.should be_nil
          @action.is_burst.should be_false
          @action.called_shot.should eq "Head"
          @action.crew_hit.should eq false
          @action.mod.should eq 0
        end
        
        it "should parse target plus called and crew" do
          FS3Combat.should_receive(:hitloc_areas).with(@target, true) { ["Head"] }
          @action = AttackAction.new(@combatant, "target/called:head,crew")
          @action.prepare.should be_nil
          @action.is_burst.should be_false
          @action.called_shot.should eq "Head"
          @action.crew_hit.should eq true
          @action.mod.should eq 0
        end
        
        it "should parse mod plus burst" do
          @action = AttackAction.new(@combatant, "target/burst,mod:3")
          @target.stub(:hitloc_areas) { ["Head"] }
          @action.prepare.should be_nil
          @action.is_burst.should be_true
          @action.called_shot.should be_nil
          @action.crew_hit.should eq false
          @action.mod.should eq 3
        end
        
        it "should raise error for invalid called shot location" do
          @action = AttackAction.new(@combatant, "target/called:head")
          @action.prepare.should eq "fs3combat.invalid_called_shot_loc"
        end
        
        it "should raise error for invalid special" do
          @action = AttackAction.new(@combatant, "target/foo:3")
          @action.prepare.should eq "fs3combat.invalid_attack_special"
        end
        
        it "should fail if multiple targets" do
          @action = AttackAction.new(@combatant, "target1 target2")
          @action.prepare.should eq "fs3combat.only_one_target"
        end
        
        it "should fail if out of ammo" do
          FS3Combat.should_receive(:check_ammo).with(@combatant, 1) { false }
          @action = AttackAction.new(@combatant, "target")
          @action.prepare.should eq "fs3combat.out_of_ammo"
        end

        it "should fail if not enough ammo for a burst" do
          FS3Combat.should_receive(:check_ammo).with(@combatant, 2) { false }
          @action = AttackAction.new(@combatant, "target/burst")
          @action.prepare.should eq "fs3combat.not_enough_ammo_for_burst"
        end

        it "should fail if trying to burst with non-auto weapon" do
          FS3Combat.should_receive(:weapon_stat).with("Rifle", "is_automatic") { false }
          @action = AttackAction.new(@combatant, "target/burst")
          @action.prepare.should eq "fs3combat.burst_fire_not_allowed"
        end

        it "should fail if trying to burst with called shot" do
          @target.stub(:hitloc_areas) { ["Head"] }
          @action = AttackAction.new(@combatant, "target/called:head , burst")
          @action.prepare.should eq "fs3combat.no_fullauto_called_shots"
        end

        it "should warn if using an explosive weapon" do
          FS3Combat.should_receive(:weapon_stat).with("Rifle", "weapon_type") { "Explosive" }
          @action = AttackAction.new(@combatant, "target1 target2")
          @action.prepare.should eq "fs3combat.use_explode_command"
        end

        it "should warn if using a suppressive weapon" do
          FS3Combat.should_receive(:weapon_stat).with("Rifle", "weapon_type") { "Suppressive" }
          @action = AttackAction.new(@combatant, "target1 target2")
          @action.prepare.should eq "fs3combat.use_suppress_command"
        end

        it "should succeed" do
          @action = AttackAction.new(@combatant, "target")
          @action.prepare.should be_nil
          @action.targets.should eq [ @target ]
        end
      end
      
      describe :resolve do
        before do
          @combatant.stub(:update)
          @action = AttackAction.new(@combatant, "target")
          @action.prepare
          @combatant.stub(:ammo) { 5 }
          FS3Combat.stub(:attack_target) { ["resultx"] }
        end
          
        it "should attack in single fire" do
          FS3Combat.should_receive(:attack_target).with(@combatant, @target, 0, nil, false) { ["result1"] }
          resolutions = @action.resolve
          resolutions[0].should eq "result1"
          resolutions.count.should eq 1
        end
        
        it "should attack in burst fire" do
          FS3Combat.should_receive(:attack_target).with(@combatant, @target, 0, nil, false) { ["result1"] }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target, 0, nil, false) { ["result2"] }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target, 0, nil, false) { ["result3"] }
          @action.is_burst = true
          resolutions = @action.resolve
          resolutions[0].should eq "fs3combat.fires_burst"
          resolutions[1].should eq "result1"
          resolutions[2].should eq "result2"
          resolutions[3].should eq "result3"
          resolutions.count.should eq 4
        end
        
        it "should limit burst fire to the number of bullets" do
          @combatant.stub(:ammo) { 2 }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target, 0, nil, false) { ["result1"] }
          FS3Combat.should_receive(:attack_target).with(@combatant, @target, 0, nil, false) { ["result2"] }
          @action.is_burst = true
          resolutions = @action.resolve
          resolutions[0].should eq "fs3combat.fires_burst"
          resolutions[1].should eq "result1"
          resolutions[2].should eq "result2"
          resolutions.count.should eq 3
        end
        
        it "should update ammo for a single shot" do
          FS3Combat.should_receive(:update_ammo).with(@combatant, 1)
          @action.resolve
        end

        it "should update ammo for a burst" do
          @action.is_burst = true
          @combatant.stub(:attack_target) { "result" }
          FS3Combat.should_receive(:update_ammo).with(@combatant, 3)
          @action.resolve
        end
        
        it "should update ammo for a burst with limited ammo" do
          @combatant.stub(:ammo) { 2 }
          @action.is_burst = true
          @combatant.stub(:attack_target) { "result" }
          FS3Combat.should_receive(:update_ammo).with(@combatant, 2)
          @action.resolve
        end
        
        it "should add an out of ammo message" do
          FS3Combat.should_receive(:attack_target).with(@combatant, @target, 0, nil, false) { ["result1"] }
          FS3Combat.should_receive(:update_ammo).with(@combatant, 1) { "out of ammo" }
          resolutions = @action.resolve
          resolutions[0].should eq "result1"
          resolutions[1].should eq "out of ammo"
        end
      end
    end
  end
end