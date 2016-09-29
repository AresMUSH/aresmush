module AresMUSH
  module Pose
    describe PoseCatcherCmd do
      
      include CommandHandlerTestHelper
    
      before do
        init_handler(PoseCatcherCmd, ":test")
        SpecHelpers.stub_translate_for_testing
      end
            
      describe :handle do
        it "should emit to the room" do
          room = double
          enactor.stub(:room) { room }
          enactor.stub(:name) { "Bob" }
          cmd.stub(:raw) { ":test" }
          PoseFormatter.should_receive(:format).with("Bob", ":test") { "Bob test"}
          Pose.should_receive(:emit_pose).with(client, "Bob test", false, false)
          handler.handle
        end
      end
    end
  end
end
