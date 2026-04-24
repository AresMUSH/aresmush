require "plugin_test_loader"

module AresMUSH
  module Manage
    describe DestroyCmd do
  
      before do
        @client = double
        @handler = DestroyCmd.new(@client, nil, nil)
        stub_translate_for_testing
        @game = double
        allow(Game).to receive(:master) { @game }
      end
      
      describe :handle do
        before do
          allow(Rooms).to receive(:is_special_room?) { false }
          allow(@game).to receive(:is_special_char?) { false }
          allow(Manage).to receive(:can_manage_object?) { true }
          @handler.name = "foo"
        end
        
        context "not found" do
          it "should emit failure if the target is not found" do
            allow(AnyTargetFinder).to receive(:find).with("foo", @enactor) { FindResult.new(nil, "an error") }
            expect(@client).to receive(:emit_failure).with("an error")
            @handler.handle
          end
        end
        
        context "special room" do
          it "should emit failure if trying to destroy a special room" do
            target = double
            allow(AnyTargetFinder).to receive(:find) { FindResult.new(target, nil) }
            allow(Rooms).to receive(:is_special_room?).with(target) { true }
            expect(@client).to receive(:emit_failure).with("manage.cannot_destroy_special_rooms")
            @handler.handle
          end
        end
        
        context "special char" do
          it "should emit failure if trying to destroy a special char" do
            target = double
            allow(AnyTargetFinder).to receive(:find) { FindResult.new(target, nil) }
            allow(@game).to receive(:is_special_char?).with(target) { true }
            expect(@client).to receive(:emit_failure).with("manage.cannot_destroy_special_chars")
            @handler.handle
          end
        end        
        
        context "not allowed" do
          it "should emit failure if the char doesn't have permission" do
            target = double
            allow(AnyTargetFinder).to receive(:find) { FindResult.new(target, nil) }
            expect(Manage).to receive(:can_manage_object?).with(@enactor, target) { false }
            expect(@client).to receive(:emit_failure).with("dispatcher.not_allowed")
            @handler.handle
          end
        end
        
        context "success" do
          before do
            @target = Character.new
            allow(@target).to receive(:id) { 1 }
            allow(@target).to receive(:print_json) { "" }
            results = FindResult.new(@target)
            allow(AnyTargetFinder).to receive(:find) { results }
            allow(@client).to receive(:program=)
            allow(@client).to receive(:emit)
          end
          
          it "should set the program to the destroy target" do
            expect(@client).to receive(:program=).with( { :destroy_target => "#C-1", :destroy_class => AresMUSH::Character } )
            @handler.handle
          end
          
          it "should emit the confirmation message" do
            expect(@client).to receive(:emit).with("%lh\nmanage.confirm_object_destroy\n%lf")
            @handler.handle
          end
        end
      end
    end
  end
end
