module AresMUSH
  module FS3Combat
    describe CombatAction do
      before do
        SpecHelpers.stub_translate_for_testing
      end

      describe :parse_targets do
        before do
          @combat = double
          @target1 = double
          @target2 = double
          @combatant = double
          @combatant.stub(:combat) { @combat }
          @target1.stub(:is_noncombatant?) { false }
          @target2.stub(:is_noncombatant?) { false }
        end
  
        it "should return error if combatant not found" do
          @combat.stub(:find_combatant).with("A") { @target1 }
          @combat.stub(:find_combatant).with("B") { nil }
          action = CombatAction.new(@combatant, "a b")
          action.parse_targets("a b").should eq "fs3combat.not_in_combat"
          action.targets.should eq []
        end
  
        it "should return error if targeting a non-combatant" do
          @combat.stub(:find_combatant).with("A") { @target1 }
          @combat.stub(:find_combatant).with("B") { @target2 }
          @target2.stub(:is_noncombatant?) { true }
          action = CombatAction.new(@combatant, "a b")
          action.parse_targets("a b").should eq "fs3combat.cant_target_noncombatant"
          action.targets.should eq []
        end
  
        it "should return names and list of targets" do
          @combat.stub(:find_combatant).with("A") { @target1 }
          @combat.stub(:find_combatant).with("B") { @target2 }

          action = CombatAction.new(@combatant, "a b")
          action.parse_targets("a b").should be_nil
          action.targets.should eq [ @target1, @target2 ]
        end
      end
    end
  end
end