module AresMUSH
  module FS3Combat
    describe EscapeAction do
      before do
        @combatant = double
        @combat = double
        @subduer = double
        
        @combatant.stub(:combat) { @combat }
        @combatant.stub(:name) { "A" }
        FS3Combat.stub(:weapon_stat) { "" }
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :prepare do
        before do
          @combat.stub(:find_combatant) { @target }
        end
        
        it "should fail if not subdued" do
          @combatant.stub(:is_subdued?) { false }
          @action = EscapeAction.new(@combatant, "")
          @action.prepare.should eq "fs3combat.not_subdued"
        end
        
        it "should succeed if subdued" do
          @combatant.stub(:is_subdued?) { true }
          @combatant.stub(:subdued_by) { @subduer }
          @action = EscapeAction.new(@combatant, "")
          @action.prepare.should be_nil
          @action.subduer.should eq @subduer
        end
      end
      
      describe :resolve do
        before do
          @subduer.stub(:name) { "Bob" }
          @combatant.stub(:is_subdued?) { true }
          @combatant.stub(:subdued_by) { @subduer }
        end
          
        it "should escape automatically if subduer is no longer subduing" do
          @combatant.stub(:is_subdued?) { false }
          @combatant.should_receive(:update).with(subdued_by: nil)
          @combatant.should_receive(:update).with(action_klass: nil)
          @combatant.should_receive(:update).with(action_args: nil)

          @action = EscapeAction.new(@combatant, "")
          @action.prepare
          resolutions = @action.resolve
          resolutions.should eq [ "fs3combat.escape_action_success" ]
        end
        
        it "should escape with a failed subdue roll" do
          @combatant.should_receive(:update).with(subdued_by: nil)
          @combatant.should_receive(:update).with(action_klass: nil)
          @combatant.should_receive(:update).with(action_args: nil)
          @action = EscapeAction.new(@combatant, "")
          @action.prepare
          
          FS3Combat.stub(:determine_attack_margin).with(@subduer, @combatant) { {hit: false} }
          resolutions = @action.resolve
          resolutions.should eq [ "fs3combat.escape_action_success" ]
        end

        it "should stay subdued with a successful subdue roll" do
          @combatant.should_not_receive(:update).with(subdued_by: nil)
          @combatant.should_not_receive(:update).with(action_klass: nil)
          @combatant.should_not_receive(:update).with(action_args: nil)
          @action = EscapeAction.new(@combatant, "")
          @action.prepare
          
          FS3Combat.stub(:determine_attack_margin).with(@subduer, @combatant) { {hit: true} }
          resolutions = @action.resolve
          resolutions.should eq [ "fs3combat.escape_action_failed" ]
        end
        
      end
    end
  end
end