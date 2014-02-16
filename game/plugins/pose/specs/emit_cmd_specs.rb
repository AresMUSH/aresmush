require_relative "../../plugin_test_loader"

module AresMUSH
  module Pose
    describe EmitCmd do
      before do 
        @cmd = double
        @client = double
        @emit = EmitCmd.new  
        @emit.cmd = @cmd
        @emit.client = @client
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :want_command? do
        it "should not want another command" do
          @cmd.stub(:root_is?).with("emit") { false }
          @emit.want_command?(@client, @cmd).should eq false
        end

        it "should want the emit command" do
          @cmd.stub(:root_is?).with("emit") { true }
          @emit.want_command?(@client, @cmd).should eq true
        end
      end
      
      describe :validate do
        it "should reject the command if a switch is specified" do
          @cmd.stub(:switch) { "sw" }
          @client.stub(:logged_in?) { true }
          @emit.validate.should eq 'pose.invalid_pose_syntax'
        end

        it "should reject the command if not logged in" do
          @client.stub(:logged_in?) { false }
          @cmd.stub(:switch) { nil }
          @emit.validate.should eq 'dispatcher.must_be_logged_in'
        end

        it "should accept the command if there's no switch" do
          @client.stub(:logged_in?) { true }
          @cmd.stub(:switch) { nil }
          @emit.validate.should eq nil
        end
      end
        
      describe :handle do
        it "should emit to the room" do
          room = double
          @client.stub(:location) { room }
          @client.stub(:name) { "name" }
          @cmd.stub(:args) { "test emit" }
          room.should_receive(:emit).with("test emit")
          @emit.handle
        end
      end

    end
  end
end