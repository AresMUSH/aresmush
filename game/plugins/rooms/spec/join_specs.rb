module AresMUSH
  module Rooms
    describe JoinCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(JoinCmd, "join someone")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
      it_behaves_like "a plugin that expects a single root" do
        let(:expected_root) { "join" }
      end
      
      describe :handle do
        before do
          handler.stub(:target) { "someone" }
        end
        
        context "target not found" do
          before do
            result = FindResult.new(nil, "error")
            SingleTargetFinder.should_receive(:find).with("someone", Character) { result }
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
        
        context "target found" do          
          it "should go to the target's room" do
            destination = double
            target = double
            target.stub(:room) { destination }
            result = FindResult.new(target, "error")
            SingleTargetFinder.stub(:find) { result }
            Rooms.should_receive(:move_to).with(client, destination)
            handler.handle
          end
        end
        
      end
    end
  end
end