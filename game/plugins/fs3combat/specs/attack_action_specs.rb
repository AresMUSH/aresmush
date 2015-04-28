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
      
      describe :check_action do
        it "should return OK if all is well" do
          @action.check_action.should be_nil
        end
        
        it "should make sure the target is in the combat" do
          # TODO not implemented
          #@combat.stub(:find_combatant).with("Target") { nil }
          #action = AttackAction.new(@combatant, "Target")
          #@action.check_action.should eq "fs3combat.not_a_valid_target"
        end
      end
      
      describe :resolve do
        before do
          @action.parse_args("Target")
        end
          
        it "should dodge if defense roll greater" do
          @target.stub(:roll_defense) { 2 }
          @combatant.stub(:roll_attack) { 1 }
          @action.resolve.should eq "fs3combat.attack_dodged"
        end

        it "should miss if attack roll fails" do
          @target.stub(:roll_defense) { 2 }
          @combatant.stub(:roll_attack) { 0 }
          @action.resolve.should eq "fs3combat.attack_missed"
        end

        describe "success" do
          before do
            @target.stub(:roll_defense) { 2 }
            @combatant.stub(:roll_attack) { 3 }
            @target.stub(:determine_hitloc) { "Head" }
            @combatant.stub(:weapon) { "Knife" }
            FS3Combat.stub(:weapon_is_stun?).with("Knife") { false }
            @target.stub(:do_damage)
            @target.stub(:determine_damage) { "M" }
          end
          
          it "should hit if attack roll greater" do
            @action.resolve.should eq "fs3combat.attack_hits"
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
      end
    end
  end
end