module AresMUSH
  module FS3Combat
    describe AttackAction do
      before do
        @combatant = double
        @target = double
        @combat = double

        allow(@combat).to receive(:find_combatant) { @target }
        allow(@combatant).to receive(:combat) { @combat }
        allow(@combatant).to receive(:weapon) { "Rifle" }
        allow(@combatant).to receive(:name) { "A" }
        allow(FS3Combat).to receive(:hitloc_areas) { [] }
        allow(@target).to receive(:name) { "Target" }
        allow(@target).to receive(:is_noncombatant?) { false }
        allow(FS3Combat).to receive(:weapon_stat) { "" }
        allow(FS3Combat).to receive(:check_ammo) { true }
        allow(FS3Combat).to receive(:update_ammo) { nil }
        stub_translate_for_testing
      end
      
      describe :prepare do
        it "should parse simple taget" do
          @action = AttackAction.new(@combatant, " target ")
          expect(@action.prepare).to be_nil
          expect(@action.is_burst).to be false
          expect(@action.called_shot).to be_nil
          expect(@action.crew_hit).to eq false
          expect(@action.mod).to eq 0
        end
        
        it "should parse target plus mod" do
          @action = AttackAction.new(@combatant, "target/mod:3")
          expect(@action.prepare).to be_nil
          expect(@action.is_burst).to be false
          expect(@action.called_shot).to be_nil
          expect(@action.crew_hit).to eq false
          expect(@action.mod).to eq 3
        end
        
        it "should parse target plus called" do
          @action = AttackAction.new(@combatant, "target/called:head")
          allow(FS3Combat).to receive(:has_hitloc?).with(@target, "Head") { true }
          expect(@action.prepare).to be_nil
          expect(@action.is_burst).to be false
          expect(@action.called_shot).to eq "Head"
          expect(@action.crew_hit).to eq false
          expect(@action.mod).to eq 0
        end
        
        it "should parse target plus called and crew" do
          allow(FS3Combat).to receive(:has_hitloc?).with(@target, "Head") { true }
          @action = AttackAction.new(@combatant, "target/called:head,crew")
          expect(@action.prepare).to be_nil
          expect(@action.is_burst).to be false
          expect(@action.called_shot).to eq "Head"
          expect(@action.crew_hit).to eq true
          expect(@action.mod).to eq 0
        end
        
        it "should parse mod plus burst" do
          @action = AttackAction.new(@combatant, "target/burst,mod:3")
          allow(@target).to receive(:hitloc_areas) { ["Head"] }
          expect(@action.prepare).to be_nil
          expect(@action.is_burst).to be true
          expect(@action.called_shot).to be_nil
          expect(@action.crew_hit).to eq false
          expect(@action.mod).to eq 3
        end
        
        it "should raise error for invalid called shot location" do
          allow(FS3Combat).to receive(:has_hitloc?).with(@target, "Head") { false }
          @action = AttackAction.new(@combatant, "target/called:head")
          expect(@action.prepare).to eq "fs3combat.invalid_called_shot_loc"
        end
        
        it "should raise error for invalid special" do
          @action = AttackAction.new(@combatant, "target/foo:3")
          expect(@action.prepare).to eq "fs3combat.invalid_attack_special"
        end
        
        it "should fail if multiple targets" do
          @action = AttackAction.new(@combatant, "target1 target2")
          expect(@action.prepare).to eq "fs3combat.only_one_target"
        end
        
        it "should fail if out of ammo" do
          expect(FS3Combat).to receive(:check_ammo).with(@combatant, 1) { false }
          @action = AttackAction.new(@combatant, "target")
          expect(@action.prepare).to eq "fs3combat.out_of_ammo"
        end

        it "should fail if not enough ammo for a burst" do
          expect(FS3Combat).to receive(:check_ammo).with(@combatant, 2) { false }
          @action = AttackAction.new(@combatant, "target/burst")
          expect(@action.prepare).to eq "fs3combat.not_enough_ammo_for_burst"
        end

        it "should fail if trying to burst with non-auto weapon" do
          expect(FS3Combat).to receive(:weapon_stat).with("Rifle", "is_automatic") { false }
          @action = AttackAction.new(@combatant, "target/burst")
          expect(@action.prepare).to eq "fs3combat.burst_fire_not_allowed"
        end

        it "should fail if trying to burst with called shot" do
          allow(@target).to receive(:hitloc_areas) { ["Head"] }
          @action = AttackAction.new(@combatant, "target/called:head , burst")
          expect(@action.prepare).to eq "fs3combat.no_fullauto_called_shots"
        end

        it "should warn if using an explosive weapon" do
          expect(FS3Combat).to receive(:weapon_stat).with("Rifle", "weapon_type") { "Explosive" }
          @action = AttackAction.new(@combatant, "target1 target2")
          expect(@action.prepare).to eq "fs3combat.use_explode_command"
        end

        it "should warn if using a suppressive weapon" do
          expect(FS3Combat).to receive(:weapon_stat).with("Rifle", "weapon_type") { "Suppressive" }
          @action = AttackAction.new(@combatant, "target1 target2")
          expect(@action.prepare).to eq "fs3combat.use_suppress_command"
        end

        it "should succeed" do
          @action = AttackAction.new(@combatant, "target")
          expect(@action.prepare).to be_nil
          expect(@action.targets).to eq [ @target ]
        end
      end
      
      describe :resolve do
        before do
          allow(@combatant).to receive(:update)
          @action = AttackAction.new(@combatant, "target")
          @action.prepare
          allow(@combatant).to receive(:ammo) { 5 }
          allow(FS3Combat).to receive(:attack_target) { ["resultx"] }
        end
          
        it "should attack in single fire" do
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target, 0, nil, false, false) { ["result1"] }
          resolutions = @action.resolve
          expect(resolutions[0]).to eq "result1"
          expect(resolutions.count).to eq 1
        end
        
        it "should attack in burst fire" do
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target, 0, nil, false, false) { ["result1"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target, 0, nil, false, false) { ["result2"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target, 0, nil, false, false) { ["result3"] }
          @action.is_burst = true
          resolutions = @action.resolve
          expect(resolutions[0]).to eq "fs3combat.fires_burst"
          expect(resolutions[1]).to eq "result1"
          expect(resolutions[2]).to eq "result2"
          expect(resolutions[3]).to eq "result3"
          expect(resolutions.count).to eq 4
        end
        
        it "should limit burst fire to the number of bullets" do
          allow(@combatant).to receive(:ammo) { 2 }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target, 0, nil, false, false) { ["result1"] }
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target, 0, nil, false, false) { ["result2"] }
          @action.is_burst = true
          resolutions = @action.resolve
          expect(resolutions[0]).to eq "fs3combat.fires_burst"
          expect(resolutions[1]).to eq "result1"
          expect(resolutions[2]).to eq "result2"
          expect(resolutions.count).to eq 3
        end
        
        it "should update ammo for a single shot" do
          expect(FS3Combat).to receive(:update_ammo).with(@combatant, 1)
          @action.resolve
        end

        it "should update ammo for a burst" do
          @action.is_burst = true
          allow(@combatant).to receive(:attack_target) { "result" }
          expect(FS3Combat).to receive(:update_ammo).with(@combatant, 3)
          @action.resolve
        end
        
        it "should update ammo for a burst with limited ammo" do
          allow(@combatant).to receive(:ammo) { 2 }
          @action.is_burst = true
          allow(@combatant).to receive(:attack_target) { "result" }
          expect(FS3Combat).to receive(:update_ammo).with(@combatant, 2)
          @action.resolve
        end
        
        it "should add an out of ammo message" do
          expect(FS3Combat).to receive(:attack_target).with(@combatant, @target, 0, nil, false, false) { ["result1"] }
          expect(FS3Combat).to receive(:update_ammo).with(@combatant, 1) { "out of ammo" }
          resolutions = @action.resolve
          expect(resolutions[0]).to eq "result1"
          expect(resolutions[1]).to eq "out of ammo"
        end
      end
    end
  end
end
