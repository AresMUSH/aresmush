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
        end
          
        it "should dodge if defense roll greater" do
          @target.stub(:roll_defense) { 2 }
          @combatant.stub(:roll_attack) { 1 }
          @action.resolve[0].should eq "fs3combat.attack_dodged"
        end

        it "should miss if attack roll fails" do
          @target.stub(:roll_defense) { 2 }
          @combatant.stub(:roll_attack) { 0 }
          @action.resolve[0].should eq "fs3combat.attack_missed"
        end

        describe "success" do
          before do
            @combatant.stub(:roll_attack) { 3 }
            @target.stub(:determine_hitloc) { "Head" }
            @combatant.stub(:weapon) { "Knife" }
            FS3Combat.stub(:weapon_is_stun?).with("Knife") { false }
            @target.stub(:do_damage)
            @target.stub(:determine_damage) { "M" }
          end
          
          describe "single fire" do
            before do 
              @target.stub(:roll_defense) { 2 }              
            end
            
            it "should hit if attack roll greater" do
              @action.resolve[0].should eq "fs3combat.attack_hits"
            end
        
            it "should determine hitloc based on successes" do
              @target.should_receive(:determine_hitloc).with(1) { "Body" }
              @action.resolve
            end
          
            it "should inflict damage" do
              @target.should_receive(:do_damage).with("M", "Knife", "Head")
              @action.resolve
            end
          
            it "should calculate damage" do
              @target.should_receive(:determine_damage).with("Head", "Knife") { "M" }
              @action.resolve
            end
          end
          
          describe "called shot" do
            before do
              @action.called_shot = "Right Leg"
            end
          
            it "should hit the desired location if margin > 2" do
              @target.stub(:roll_defense) { 0 }
              @target.should_not_receive(:determine_hitloc)
              @target.should_receive(:do_damage).with("M", "Knife", "Right Leg")
              @action.resolve
            end
            
            it "should roll random hitloc with penalty if margin <= 2" do
              @target.should_receive(:determine_hitloc).with(-1) { "Body" }
              @target.stub(:roll_defense) { 2 }
              @target.should_receive(:do_damage).with("M", "Knife", "Body")
              @action.resolve
            end
          end
          
          describe "burst fire" do
            before do
              @action.is_burst = true
              @target.should_receive(:roll_defense).exactly(3).times.and_return(2, 4, 3)
            end
          
            it "should do three damage messages" do
              resolutions = @action.resolve
              resolutions[0].should eq "fs3combat.fires_burst"
              resolutions[1].should eq "fs3combat.attack_hits"
              resolutions[2].should eq "fs3combat.attack_dodged"
              resolutions[3].should eq "fs3combat.attack_hits"
            end
          end
        end
      end
    end
  end
end