module AresMUSH
  module FS3Combat
    describe CombatAction do
      before do
        stub_translate_for_testing
      end

      describe :parse_targets do
        before do
          @combat = double
          @target1 = double
          @target2 = double
          @combatant = double
          allow(@combatant).to receive(:combat) { @combat }
          allow(@target1).to receive(:is_noncombatant?) { false }
          allow(@target2).to receive(:is_noncombatant?) { false }
        end
  
        it "should return error if combatant not found" do
          allow(@combat).to receive(:find_combatant).with("A") { @target1 }
          allow(@combat).to receive(:find_combatant).with("B") { nil }
          action = CombatAction.new(@combatant, "a b")
          expect(action.parse_targets("a b")).to eq "fs3combat.not_in_combat"
          expect(action.targets).to eq []
        end
  
        it "should return error if targeting a non-combatant" do
          allow(@combat).to receive(:find_combatant).with("A") { @target1 }
          allow(@combat).to receive(:find_combatant).with("B") { @target2 }
          allow(@target2).to receive(:is_noncombatant?) { true }
          action = CombatAction.new(@combatant, "a b")
          expect(action.parse_targets("a b")).to eq "fs3combat.cant_target_noncombatant"
          expect(action.targets).to eq []
        end
  
        it "should return names and list of targets" do
          allow(@combat).to receive(:find_combatant).with("A") { @target1 }
          allow(@combat).to receive(:find_combatant).with("B") { @target2 }

          action = CombatAction.new(@combatant, "a b")
          expect(action.parse_targets("a b")).to be_nil
          expect(action.targets).to eq [ @target1, @target2 ]
        end
      end
    end
  end
end
