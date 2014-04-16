require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe DestroyCmd do
      include PluginCmdTestHelper
  
      before do
        init_handler(DestroyCmd, "destroy foo")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :crack! do
        it "should set the target" do          
          handler.crack!
          handler.target.should eq 'foo'
        end
      end
      
      describe :handle do
        before do
          game = double
          Game.stub(:master) { game }
          game.stub(:is_special_room?) { false }
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
            game = double
            AnyTargetFinder.stub(:find) { FindResult.new(target, nil) }
            Game.stub(:master) { game }
            game.stub(:is_special_room?).with(target) { true }
            client.should_receive(:emit_failure).with("manage.cannot_destroy_special_rooms")
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
            client.should_receive(:emit).with("manage.confirm_object_destroy")
            handler.handle
          end
        end
      end
    end
  end
end