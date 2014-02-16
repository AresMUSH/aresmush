require_relative "../../plugin_test_loader"

module AresMUSH
  module Pose
    describe PoseCmd do
      include CommandTestHelper
      
      before do
        init_handler(PoseCmd, "pose")
      end
      
      describe :want_command? do
        it "should not want another command" do
          cmd.stub(:root_is?).with("pose") { false }
          handler.want_command?(client, cmd).should eq false
        end

        it "should want the pose command" do
          handler.want_command?(client, cmd).should eq true
        end
      end
      
      describe :validate do
        before do
          Locale.stub(:translate).with("dispatcher.must_be_logged_in") { "dispatcher.must_be_logged_in" }
          Locale.stub(:translate).with("pose.invalid_pose_syntax") { "pose.invalid_pose_syntax" }
        end
        
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
          client.stub(:name) { "Bob" }
          cmd.stub(:args) { "test pose" }
          Locale.stub(:translate).with("object.pose", :name => "Bob", :msg => "test pose") { "Bob test" }
          room.should_receive(:emit).with("Bob test")
          handler.handle
        end
      end

    end
  end
end