module AresMUSH
  module FS3Combat
    describe DistractAction do
      before do
        @combatant = double
        @combat = double

        allow(@combatant).to receive(:combat) { @combat }
        allow(@combatant).to receive(:weapon) { "Unarmed" }
        allow(@combatant).to receive(:name) { "A" }
        allow(FS3Combat).to receive(:weapon_stat).with("Unarmed", "weapon_type") { "Melee" }
        allow(@combatant).to receive(:is_npc?) { false }
        allow(@combatant).to receive(:associated_model) { double }
        allow(Achievements).to receive(:award_achievement) {}
        stub_translate_for_testing
      end
      
      describe :resolve do
        before do
          @target1 = double
          allow(@target1).to receive(:name) { "T1" }
          allow(@target1).to receive(:is_noncombatant?) { false }
          allow(@combat).to receive(:find_combatant).with("Target1") { @target1 }
          allow(@combatant).to receive(:log)
        end
          
        it "should distract successfully" do
          @action = DistractAction.new(@combatant, "target1")
          @action.prepare
          
          expect(FS3Combat).to receive(:roll_attack).with(@combatant, @target1) { 3 }
          expect(@target1).to receive(:roll_ability).with("Composure") { 2 }
          expect(@target1).to receive(:update).with(action_klass: nil)
          expect(@target1).to receive(:update).with(action_args: nil)
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.distract_successful_msg" ]
        end

        it "should distract unsuccessfully" do
          @action = DistractAction.new(@combatant, "target1")
          @action.prepare
          expect(FS3Combat).to receive(:roll_attack).with(@combatant, @target1) { 2 }
          expect(@target1).to receive(:roll_ability).with("Composure") { 3 }
          expect(@target1).to_not receive(:update)
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.distract_failed_msg" ]
        end
      end
    end
  end
end
