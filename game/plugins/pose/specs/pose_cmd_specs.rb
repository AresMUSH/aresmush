require_relative "../../plugin_test_loader"

module AresMUSH
  module Pose
    describe PoseCmd do
  
      before do
        @client = double
        @enactor = double
        @handler = PoseCmd.new(@client, Command.new("pose a message"), @enactor)
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :handle do
        it "should emit to the room" do
          room = double
          @client.stub(:room) { room }
          @handler.stub(:message) { "a message" }
          Pose.should_receive(:emit_pose).with(@enactor, "a message", false, false)
          @handler.handle
        end
      end
      
      describe :message do
        before do
          @enactor.stub(:name) { "Bob" }          
        end
        
        it "should format an emit message" do
          @handler = PoseCmd.new(@client, Command.new("emit test"), @enactor)
          PoseFormatter.should_receive(:format).with("Bob", "\\test") { "formatted msg" }
          @handler.message.should eq "formatted msg"
        end

        it "should format a say message" do
          @handler = PoseCmd.new(@client, Command.new("say test"), @enactor)
          PoseFormatter.should_receive(:format).with("Bob", "\"test") { "formatted msg" }
          @handler.message.should eq "formatted msg"
        end

        it "should format a pose message" do
          @handler = PoseCmd.new(@client, Command.new("pose test"), @enactor)
          PoseFormatter.should_receive(:format).with("Bob", ":test") { "formatted msg" }
          @handler.message.should eq "formatted msg"
        end

        it "should format an ooc say message" do
          Global.stub(:read_config).with("pose", "ooc_color") { '%xc' }
          @handler = PoseCmd.new(@client, Command.new("ooc test"), @enactor)
          PoseFormatter.should_receive(:format).with("Bob", "test") { "formatted msg" }
          @handler.message.should eq "%xc<OOC>%xn formatted msg"
        end
      end     
    end
  end
end