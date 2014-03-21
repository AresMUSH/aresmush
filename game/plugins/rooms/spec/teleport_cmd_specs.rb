module AresMUSH
  module Rooms
    describe TeleportCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(TeleportCmd, "teleport somewhere")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
      it_behaves_like "a plugin that expects a single root" do
        let(:expected_root) { "teleport" }
      end
      
      describe :handle do
        before do
          handler.stub(:destination) { "Somewhere" }
        end
        
        context "destination not found" do
          before do
            result = FindResult.new(nil, "error")
            SingleTargetFinder.should_receive(:find).with("Somewhere", Room) { result }
            client.stub(:emit_failure)
          end  
          
          it "should emit failure" do
            client.should_receive(:emit_failure).with("error")          
            handler.handle
          end
          
          it "should not go anywhere" do
            Rooms.should_not_receive(:move_to)
            handler.handle
          end
        end
        
        context "destination found" do          
          it "should go to the destination" do
            dest = double
            result = FindResult.new(dest, "error")
            SingleTargetFinder.stub(:find) { result }
            Rooms.should_receive(:move_to).with(client, dest)
            handler.handle
          end
        end
        
      end
    end
  end
end