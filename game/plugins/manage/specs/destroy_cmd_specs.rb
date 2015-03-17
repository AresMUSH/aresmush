require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe DestroyCmd do
      include PluginCmdTestHelper
      include GameTestHelper
  
      before do
        init_handler(DestroyCmd, "destroy foo")
        SpecHelpers.stub_translate_for_testing
        stub_game_master
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :crack! do
        it "should set the target" do          
          handler.crack!
          handler.name.should eq 'foo'
        end
      end
      
      describe :handle do
        before do
          game.stub(:is_special_room?) { false }
          game.stub(:is_special_char?) { false }
          Manage.stub(:can_manage_object?) { true }
          handler.crack!
        end
        
        context "not found" do
          it "should emit failure if the target is not found" do
            AnyTargetFinder.stub(:find).with("foo", client) { FindResult.new(nil, "an error") }
            client.should_receive(:emit_failure).with("an error")
            handler.handle
          end
        end
        
        context "special room" do
          it "should emit failure if trying to destroy a special room" do
            target = double
            AnyTargetFinder.stub(:find) { FindResult.new(target, nil) }
            game.stub(:is_special_room?).with(target) { true }
            client.should_receive(:emit_failure).with("manage.cannot_destroy_special_rooms")
            handler.handle
          end
        end
        
        context "special char" do
          it "should emit failure if trying to destroy a special char" do
            target = double
            AnyTargetFinder.stub(:find) { FindResult.new(target, nil) }
            game.stub(:is_special_char?).with(target) { true }
            client.should_receive(:emit_failure).with("manage.cannot_destroy_special_chars")
            handler.handle
          end
        end
        
        context "not allowed" do
          it "should emit failure if the char doesn't have permission" do
            target = double
            AnyTargetFinder.stub(:find) { FindResult.new(target, nil) }
            Manage.should_receive(:can_manage_object?).with(client.char, target) { false }
            client.should_receive(:emit_failure).with("dispatcher.not_allowed")
            handler.handle
          end
        end
        
        context "success" do
          before do
            @target = double.as_null_object
            AnyTargetFinder.stub(:find) { @target }
            client.stub(:program=)
            client.stub(:emit)
          end
          
          it "should set the program to the destroy target" do
            client.should_receive(:program=).with( { :destroy_target => @target } )
            handler.handle
          end
          
          it "should emit the confirmation message" do
            client.should_receive(:emit).with("%l1%rmanage.confirm_object_destroy%r%l1")
            handler.handle
          end
        end
      end
    end
  end
end