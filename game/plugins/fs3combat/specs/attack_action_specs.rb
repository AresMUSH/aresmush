module AresMUSH
  module FS3Combat
    describe AttackAction do
      before do
        @action = AttackAction.new
        @combatant = Combatant.new(:name => "Bob")
        @target = double
        @combat = double

        @target.stub(:name) { "Target" }
        @action.stub(:combat) { @combat }
        @action.stub(:combatant) { @combatant }
        @action.stub(:parse_targets)
        @action.stub(:targets) { [@target] }
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :initialize do
        it "should parse simple taget" do
          @action.parse_args(" target ")
          @action.name.should eq "Bob"
          @action.is_burst.should be_false
          @action.called_shot.should be_nil
          @action.mod.should eq 0
        end
        
        it "should parse target plus mod" do
          @action.parse_args("target/mod:3")
          @action.name.should eq "Bob"
          @action.is_burst.should be_false
          @action.called_shot.should be_nil
          @action.mod.should eq 3
        end
        
        it "should parse target plus called and burst" do
          @action.parse_args("target/called:head , burst")
          @action.name.should eq "Bob"
          @action.is_burst.should be_true
          @action.called_shot.should eq "Head"
          @action.mod.should eq 0
        end
        
        it "should raise error for invalid special" do
          expect { @action.parse_args("target/foo:3") }.to raise_error("fs3combat.invalid_attack_special")
        end
      end
      
      describe :resolve do
        before do
          @action.parse_args("Target")
          @combatant.stub(:update_ammo) { }
          @combatant.should_receive(:attack_target).with(@target, nil, 0) { "result1" }
        end
          
        it "should attack in single fire" do
          resolutions = @action.resolve
          resolutions[0].should eq "result1"
          resolutions.count.should eq 1
        end
        
        it "should attack in burst fire" do
          @combatant.should_receive(:attack_target).with(@target, nil, 0) { "result2" }
          @combatant.should_receive(:attack_target).with(@target, nil, 0) { "result3" }
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
          @combatant.should_receive(:attack_target).with(@target, nil, 0) { "result2" }
          @action.is_burst = true
          resolutions = @action.resolve
          resolutions[0].should eq "fs3combat.fires_burst"
          resolutions[1].should eq "result1"
          resolutions[2].should eq "result2"
          resolutions.count.should eq 3
        end
        
        it "should update ammo for a single shot" do
          @combatant.should_receive(:update_ammo).with(1)
          @action.resolve
        end

        it "should update ammo for a burst" do
          @action.is_burst = true
          @combatant.stub(:attack_target) { "result" }
          @combatant.should_receive(:update_ammo).with(3)
          @action.resolve
        end
        
        it "should update ammo for a burst with limited ammo" do
          @combatant.stub(:ammo) { 2 }
          @action.is_burst = true
          @combatant.stub(:attack_target) { "result" }
          @combatant.should_receive(:update_ammo).with(2)
          @action.resolve
        end
        
        it "should add an out of ammo message" do
          @combatant.should_receive(:update_ammo).with(1) { "out of ammo" }
          resolutions = @action.resolve
          resolutions[0].should eq "result1"
          resolutions[1].should eq "out of ammo"
        end
      end
    end
  end
end