require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe DestroyCmd do
  
      before do
        @client = double
        @handler = DestroyCmd.new(@client, nil, nil)
        SpecHelpers.stub_translate_for_testing
        @game = double
        Game.stub(:master) { @game }
      end
      
      describe :handle do
        before do
          Rooms::Api.stub(:is_special_room?) { false }
          @game.stub(:is_special_char?) { false }
          Manage.stub(:can_manage_object?) { true }
          FS3Combat::Api.stub(:is_in_combat?) { false }
          @handler.name = "foo"
        end
        
        context "not found" do
          it "should emit failure if the target is not found" do
            AnyTargetFinder.stub(:find).with("foo", @enactor) { FindResult.new(nil, "an error") }
            @client.should_receive(:emit_failure).with("an error")
            @handler.handle
          end
        end
        
        context "special room" do
          it "should emit failure if trying to destroy a special room" do
            target = double
            AnyTargetFinder.stub(:find) { FindResult.new(target, nil) }
            Rooms::Api.stub(:is_special_room?).with(target) { true }
            @client.should_receive(:emit_failure).with("manage.cannot_destroy_special_rooms")
            @handler.handle
          end
        end
        
        context "special char" do
          it "should emit failure if trying to destroy a special char" do
            target = double
            AnyTargetFinder.stub(:find) { FindResult.new(target, nil) }
            @game.stub(:is_special_char?).with(target) { true }
            @client.should_receive(:emit_failure).with("manage.cannot_destroy_special_chars")
            @handler.handle
          end
        end
        
        it "should emit failure if trying to destroy a char in combat" do
          target = double
          target.stub(:class) { "AresMUSH::Character"}
          AnyTargetFinder.stub(:find) { FindResult.new(target, nil) }
          FS3Combat::Api.stub(:is_in_combat?).with(target) { true }
          @client.should_receive(:emit_failure).with("manage.cannot_destroy_in_combat")
          @handler.handle
        end
        
        context "not allowed" do
          it "should emit failure if the char doesn't have permission" do
            target = double
            AnyTargetFinder.stub(:find) { FindResult.new(target, nil) }
            Manage.should_receive(:can_manage_object?).with(@enactor, target) { false }
            @client.should_receive(:emit_failure).with("dispatcher.not_allowed")
            @handler.handle
          end
        end
        
        context "success" do
          before do
            @target = Character.new
            @target.stub(:id) { 1 }
            @target.stub(:print_json) { "" }
            results = FindResult.new(@target)
            AnyTargetFinder.stub(:find) { results }
            @client.stub(:program=)
            @client.stub(:emit)
          end
          
          it "should set the program to the destroy target" do
            @client.should_receive(:program=).with( { :destroy_target => "#C-1", :destroy_class => AresMUSH::Character } )
            @handler.handle
          end
          
          it "should emit the confirmation message" do
            @client.should_receive(:emit).with("%lh\nmanage.confirm_object_destroy\n%lf")
            @handler.handle
          end
        end
      end
    end
  end
end