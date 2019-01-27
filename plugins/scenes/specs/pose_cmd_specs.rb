require_relative "../../plugin_test_loader"

module AresMUSH
  module Scenes
    describe PoseCmd do
  
      before do
        @client = double
        @enactor = double
        allow(@enactor).to receive(:ooc_name) { "Bob OOC" }
        allow(@enactor).to receive(:name) { "Bob" }
        @handler = PoseCmd.new(@client, Command.new("pose a message"), @enactor)
        stub_translate_for_testing
      end
      
      describe :handle do
        it "should emit to the room" do
          room = double
          allow(@client).to receive(:room) { room }
          allow(Places).to receive(:reset_place_if_moved)
          allow(@handler).to receive(:message) { "a message" }
          expect(Scenes).to receive(:emit_pose).with(@enactor, "a message", false, false)
          @handler.handle
        end
      end
      
      describe :message do
        before do
          allow(@enactor).to receive(:name) { "Bob" }          
        end
        
        it "should format an emit message" do
          @handler = PoseCmd.new(@client, Command.new("emit test"), @enactor)
          expect(PoseFormatter).to receive(:format).with("Bob", "\\test") { "formatted msg" }
          expect(@handler.message("Bob")).to eq "formatted msg"
        end

        it "should format a say message" do
          @handler = PoseCmd.new(@client, Command.new("say test"), @enactor)
          expect(PoseFormatter).to receive(:format).with("Bob", "\"test") { "formatted msg" }
          expect(@handler.message("Bob")).to eq "formatted msg"
        end

        it "should format a pose message" do
          @handler = PoseCmd.new(@client, Command.new("pose test"), @enactor)
          expect(PoseFormatter).to receive(:format).with("Bob", ":test") { "formatted msg" }
          expect(@handler.message("Bob")).to eq "formatted msg"
        end
      end     
    end
  end
end
