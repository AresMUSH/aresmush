module AresMUSH
  module FS3Combat
    describe SubdueAction do
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
      
      describe :prepare do
        before do
          allow(@combat).to receive(:find_combatant) { @target }
          @target = double
          allow(@target).to receive(:name) { "Target" }
          allow(@target).to receive(:is_noncombatant?) { false }
        end
        
        it "should fail if too many targets" do
          @action = SubdueAction.new(@combatant, "target1 target2")
          expect(@action.prepare).to eq "fs3combat.only_one_target"
        end
        
        it "should fail if not a melee weapon" do
          expect(FS3Combat).to receive(:weapon_stat).with("Unarmed", "weapon_type") { "Explosive" }
          @action = SubdueAction.new(@combatant, "target1")
          expect(@action.prepare).to eq "fs3combat.subdue_uses_melee"
        end
        
        it "should allow a single target" do
          @action = SubdueAction.new(@combatant, "target")
          expect(@action.prepare).to be_nil
          expect(@action.targets).to eq [ @target ]
        end
      end
      
      describe :resolve do
        before do
          @target1 = double
          allow(@target1).to receive(:name) { "T1" }
          allow(@target1).to receive(:is_noncombatant?) { false }
          allow(@target1).to receive(:subdued_by) { nil }

          allow(@combat).to receive(:find_combatant).with("Target1") { @target1 }
        end
          
        it "should subdue successfully" do
          @action = SubdueAction.new(@combatant, "target1")
          @action.prepare
          results = { hit: true, attacker_net_successes: 3 }
          expect(FS3Combat).to receive(:determine_attack_margin).with(@combatant, @target1) { results }
          expect(@target1).to receive(:update).with(subdued_by: @combatant)
          expect(@target1).to receive(:update).with(action_klass: nil)
          expect(@target1).to receive(:update).with(action_args: nil)
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.subdue_action_success" ]
        end

        it "should subdue unsuccessfully" do
          @action = SubdueAction.new(@combatant, "target1")
          @action.prepare
          expect(FS3Combat).to receive(:determine_attack_margin).with(@combatant, @target1) { { hit: false } }
          expect(@target1).to_not receive(:update)
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.subdue_action_failed" ]
        end
        
        it "should continue subduing without rolling" do
          @action = SubdueAction.new(@combatant, "target1")
          @action.prepare
          expect(@target1).to receive(:subdued_by) { @combatant }
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.continues_subduing" ]
        end
      end
    end
  end
end
