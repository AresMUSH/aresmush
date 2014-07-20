module AresMUSH
  module Pose
    describe PoseCatcher do
      
      include PluginCmdTestHelper
    
      before do
        init_handler(PoseCatcher, ":test")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
    
      describe :want_command? do
        it "should not want another command" do
          cmd.stub(:raw) { "foo" }
          handler.want_command?(client, cmd).should eq false
        end

        it "should want the pose shortcut" do
          cmd.stub(:raw) { ":test" }
          handler.want_command?(client, cmd).should eq true
        end

        it "should want the say shortcut" do
          cmd.stub(:raw) { "\"test" }
          handler.want_command?(client, cmd).should eq true
        end
      
        it "should want the semipose shortcut" do
          cmd.stub(:raw) { ";test" }
          handler.want_command?(client, cmd).should eq true
        end
      
        it "should want the emit shortcut" do
          cmd.stub(:raw) { "\\test" }
          handler.want_command?(client, cmd).should eq true
        end
      end    
            
      describe :handle do
        it "should emit to the room" do
          room = double
          client.stub(:room) { room }
          client.stub(:name) { "Bob" }
          cmd.stub(:raw) { ":test" }
          PoseFormatter.should_receive(:format).with("Bob", ":test") { "Bob test"}
          Pose.should_receive(:emit_pose).with(room, "Bob test")
          handler.handle
        end
      end
    end
  end
end
