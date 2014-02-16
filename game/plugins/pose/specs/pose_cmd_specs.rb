require_relative "../../plugin_test_loader"

module AresMUSH
  module Pose
    describe PoseCmd do
      include CommandTestHelper
  
      before do
        init_handler(PoseCmd, "pose")
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :want_command? do
        it "should not want another command" do
          cmd.stub(:root_is?).with("pose") { false }
          cmd.stub(:root_is?).with("say") { false }
          cmd.stub(:root_is?).with("emit") { false }
          cmd.stub(:root_is?).with("ooc") { false }
          handler.want_command?(client, cmd).should eq false
        end

        it "should want the pose command" do
          set_root_to_pose
          handler.want_command?(client, cmd).should eq true
        end

        it "should want the say command" do
          set_root_to_say
          handler.want_command?(client, cmd).should eq true
        end
      
        it "should want the emit command" do
          set_root_to_emit
          handler.want_command?(client, cmd).should eq true
        end      
      
        it "should want the ooc say command" do
          set_root_to_ooc_say
          handler.want_command?(client, cmd).should eq true
        end      
      end
  
      describe :validate do
        it "should reject the command if a switch is specified" do
          cmd.stub(:switch) { "sw" }
          client.stub(:logged_in?) { true }
          handler.validate.should eq 'pose.invalid_pose_syntax'
        end

        it "should reject the command if not logged in" do
          client.stub(:logged_in?) { false }
          cmd.stub(:switch) { nil }
          handler.validate.should eq 'dispatcher.must_be_logged_in'
        end

        it "should accept the command otherwise" do
          client.stub(:logged_in?) { true }
          cmd.stub(:switch) { nil }
          handler.validate.should eq nil
        end
      end
    
      describe :handle do
        it "should emit to the room" do
          room = double
          client.stub(:room) { room }
          handler.stub(:message) { "a message" }
          room.should_receive(:emit).with("a message")
          handler.handle
        end
      end
      
      describe :message do
        before do
          client.stub(:name) { "Bob" }          
        end
        
        it "should format an emit message" do
          cmd.stub(:args) { "test" }
          set_root_to_emit
          PoseFormatter.should_receive(:format).with("Bob", "\\test") { "formatted msg" }
          handler.message.should eq "formatted msg"
        end

        it "should format a say message" do
          cmd.stub(:args) { "test" }
          set_root_to_say
          PoseFormatter.should_receive(:format).with("Bob", "\"test") { "formatted msg" }
          handler.message.should eq "formatted msg"
        end

        it "should format a pose message" do
          cmd.stub(:args) { "test" }
          set_root_to_pose
          PoseFormatter.should_receive(:format).with("Bob", ":test") { "formatted msg" }
          handler.message.should eq "formatted msg"
        end

        it "should format an ooc say message" do
          cmd.stub(:args) { "test" }
          set_root_to_ooc_say
          PoseFormatter.should_receive(:format).with("Bob", "test") { "formatted msg" }
          handler.message.should eq "%xc<OOC>%xn formatted msg"
        end
      end
      
  
      def set_root_to_pose
        cmd.stub(:root_is?).with("pose") { true }
        cmd.stub(:root_is?).with("say") { false }
        cmd.stub(:root_is?).with("emit") { false }
        cmd.stub(:root_is?).with("ooc") { false }
      end
        
      def set_root_to_say
        cmd.stub(:root_is?).with("pose") { false }
        cmd.stub(:root_is?).with("say") { true }
        cmd.stub(:root_is?).with("emit") { false }
        cmd.stub(:root_is?).with("ooc") { false }
      end
        
      def set_root_to_emit
        cmd.stub(:root_is?).with("pose") { false }
        cmd.stub(:root_is?).with("say") { false }
        cmd.stub(:root_is?).with("emit") { true }
        cmd.stub(:root_is?).with("ooc") { false }
      end
        
      def set_root_to_ooc_say
        cmd.stub(:root_is?).with("pose") { false }
        cmd.stub(:root_is?).with("say") { false }
        cmd.stub(:root_is?).with("emit") { false }
        cmd.stub(:root_is?).with("ooc") { true }
      end
    end
  end
end