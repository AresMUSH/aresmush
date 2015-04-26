module AresMUSH
  module FS3Combat
    describe AttackAction do
      before do
        @combatant = Combatant.new(:name => "Bob")
        @combat = double
        @combatant.stub(:combat) { @combat }
        @target = double
        @combat.stub(:find_combatant).with("Target") { @target }
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :initialize do
        it "should parse simple taget" do
          action = AttackAction.new(@combatant, " target ")
          action.name.should eq "Bob"
          action.target.should eq "Target"
          action.is_burst.should be_false
          action.called.should be_nil
          action.mod.should eq 0
        end
        
        it "should parse target plus mod" do
          action = AttackAction.new(@combatant, "target/mod:3")
          action.name.should eq "Bob"
          action.target.should eq "Target"
          action.is_burst.should be_false
          action.called.should be_nil
          action.mod.should eq 3
        end
        
        it "should parse target plus called and burst" do
          action = AttackAction.new(@combatant, "target/called:head , burst")
          action.name.should eq "Bob"
          action.target.should eq "Target"
          action.is_burst.should be_true
          action.called.should eq "Head"
          action.mod.should eq 0
        end
        
        it "should raise error for invalid special" do
          expect { action = AttackAction.new(@combatant, "target/foo:3") }.to raise_error("fs3combat.invalid_attack_special")
        end
      end
      
      describe :check_action do
        it "should return OK if all is well" do
          action = AttackAction.new(@combatant, "Target")
          action.check_action.should be_nil
        end
        
        it "should make sure the target is in the combat" do
          @combat.stub(:find_combatant).with("Target") { nil }
          action = AttackAction.new(@combatant, "Target")
          action.check_action.should eq "fs3combat.not_a_valid_target"
        end
      end
      
      describe :resolve do
        it "should dodge if defense roll greater" do
          @target.stub(:roll_defense) { 2 }
          @combatant.stub(:roll_attack) { 1 }
          action = AttackAction.new(@combatant, "Target")
          action.resolve[0].should eq "fs3combat.attack_dodged"
        end

        it "should miss if attack roll fails" do
          @target.stub(:roll_defense) { 2 }
          @combatant.stub(:roll_attack) { 0 }
          action = AttackAction.new(@combatant, "Target")
          action.resolve[0].should eq "fs3combat.attack_missed"
        end

        it "should hit if attack roll greater" do
          @target.stub(:roll_defense) { 2 }
          @combatant.stub(:roll_attack) { 3 }
          action = AttackAction.new(@combatant, "Target")
          action.resolve[0].should eq "fs3combat.attack_hits"
        end
      end
    end
  end
end