module AresMUSH
  module FS3Combat
    describe EscapeAction do
      before do
        @combatant = double
        @combat = double
        @subduer = double
        
        allow(@combatant).to receive(:combat) { @combat }
        allow(@combatant).to receive(:name) { "A" }
        allow(FS3Combat).to receive(:weapon_stat) { "" }
        stub_translate_for_testing
      end
      
      describe :prepare do
        before do
          allow(@combat).to receive(:find_combatant) { @target }
        end
        
        it "should fail if not subdued" do
          allow(@combatant).to receive(:is_subdued?) { false }
          @action = EscapeAction.new(@combatant, "")
          expect(@action.prepare).to eq "fs3combat.not_subdued"
        end
        
        it "should succeed if subdued" do
          allow(@combatant).to receive(:is_subdued?) { true }
          allow(@combatant).to receive(:subdued_by) { @subduer }
          @action = EscapeAction.new(@combatant, "")
          expect(@action.prepare).to be_nil
          expect(@action.subduer).to eq @subduer
        end
      end
      
      describe :resolve do
        before do
          allow(@subduer).to receive(:name) { "Bob" }
          allow(@combatant).to receive(:is_subdued?) { true }
          allow(@combatant).to receive(:subdued_by) { @subduer }
        end
          
        it "should escape automatically if subduer is no longer subduing" do
          allow(@combatant).to receive(:is_subdued?) { false }
          expect(@combatant).to receive(:update).with(subdued_by: nil)
          expect(@combatant).to receive(:update).with(action_klass: nil)
          expect(@combatant).to receive(:update).with(action_args: nil)

          @action = EscapeAction.new(@combatant, "")
          @action.prepare
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.escape_action_success" ]
        end
        
        it "should escape with a failed subdue roll" do
          expect(@combatant).to receive(:update).with(subdued_by: nil)
          expect(@combatant).to receive(:update).with(action_klass: nil)
          expect(@combatant).to receive(:update).with(action_args: nil)
          @action = EscapeAction.new(@combatant, "")
          @action.prepare
          
          allow(FS3Combat).to receive(:determine_attack_margin).with(@subduer, @combatant) { {hit: false} }
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.escape_action_success" ]
        end

        it "should stay subdued with a successful subdue roll" do
          expect(@combatant).to_not receive(:update).with(subdued_by: nil)
          expect(@combatant).to_not receive(:update).with(action_klass: nil)
          expect(@combatant).to_not receive(:update).with(action_args: nil)
          @action = EscapeAction.new(@combatant, "")
          @action.prepare
          
          allow(FS3Combat).to receive(:determine_attack_margin).with(@subduer, @combatant) { {hit: true} }
          resolutions = @action.resolve
          expect(resolutions).to eq [ "fs3combat.escape_action_failed" ]
        end
        
      end
    end
  end
end
