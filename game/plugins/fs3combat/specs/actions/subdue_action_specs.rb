module AresMUSH
  module FS3Combat
    describe SubdueAction do
      before do
        @combatant = double
        @combat = double

        @combatant.stub(:combat) { @combat }
        @combatant.stub(:weapon) { "Unarmed" }
        @combatant.stub(:name) { "A" }
        FS3Combat.stub(:weapon_stat).with("Unarmed", "weapon_type") { "Melee" }
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :prepare do
        before do
          @combat.stub(:find_combatant) { @target }
          @target = double
          @target.stub(:name) { "Target" }
          @target.stub(:is_noncombatant?) { false }
        end
        
        it "should fail if too many targets" do
          @action = SubdueAction.new(@combatant, "target1 target2")
          @action.prepare.should eq "fs3combat.only_one_target"
        end
        
        it "should fail if not a melee weapon" do
          FS3Combat.should_receive(:weapon_stat).with("Unarmed", "weapon_type") { "Explosive" }
          @action = SubdueAction.new(@combatant, "target1")
          @action.prepare.should eq "fs3combat.subdue_uses_melee"
        end
        
        it "should allow a single target" do
          @action = SubdueAction.new(@combatant, "target")
          @action.prepare.should be_nil
          @action.targets.should eq [ @target ]
        end
      end
      
      describe :resolve do
        before do
          @target1 = double
          @target1.stub(:name) { "T1" }
          @target1.stub(:is_noncombatant?) { false }

          @combat.stub(:find_combatant).with("Target1") { @target1 }
        end
          
        it "should subdue successfully" do
          @action = SubdueAction.new(@combatant, "target1")
          @action.prepare
          results = { hit: true, attacker_net_successes: 3 }
          FS3Combat.should_receive(:determine_attack_margin).with(@combatant, @target1) { results }
          @target1.should_receive(:update).with(subdued_by: @combatant)
          @target1.should_receive(:update).with(action_klass: nil)
          @target1.should_receive(:update).with(action_args: nil)
          resolutions = @action.resolve
          resolutions.should eq [ "fs3combat.subdue_action_success" ]
        end

        it "should subdue unsuccessfully" do
          @action = SubdueAction.new(@combatant, "target1")
          @action.prepare
          FS3Combat.should_receive(:determine_attack_margin).with(@combatant, @target1) { { hit: false } }
          @target1.should_not_receive(:update)
          resolutions = @action.resolve
          resolutions.should eq [ "fs3combat.subdue_action_failed" ]
        end
      end
    end
  end
end