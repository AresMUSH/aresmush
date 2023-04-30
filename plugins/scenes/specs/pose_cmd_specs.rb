require "plugin_test_loader"

module AresMUSH
  module Scenes
    describe PoseCmd do
  
      before do
        @client = double
        @enactor = double
        allow(@enactor).to receive(:name) { "Bob" }
        stub_translate_for_testing
      end
      
      describe :handle do
        it "should emit a pose" do
          room = double
          @handler = PoseCmd.new(@client, Command.new("pose a message"), @enactor)
          allow(@client).to receive(:room) { room }
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { true }
          expect(PoseFormatter).to receive(:format).with("Bob", ":a message") { "Bob a message"}
          expect(Scenes).to receive(:emit_pose).with(@enactor, "Bob a message", false, false)
          @handler.handle
        end
        
        it "should emit a say" do
          room = double
          @handler = PoseCmd.new(@client, Command.new("say a message"), @enactor)
          allow(@client).to receive(:room) { room }
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { true }
          expect(PoseFormatter).to receive(:format).with("Bob", "\"a message") { "Bob says a message"}
          expect(Scenes).to receive(:emit_pose).with(@enactor, "Bob says a message", false, false)
          @handler.handle
        end
        
        it "should emit an emit" do
          room = double
          @handler = PoseCmd.new(@client, Command.new("emit a message"), @enactor)
          allow(@client).to receive(:room) { room }
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { true }
          expect(Scenes).to receive(:emit_pose).with(@enactor, "a message", true, false)
          @handler.handle
        end
        
        it "should emit an ooc" do
          room = double
          @handler = PoseCmd.new(@client, Command.new("ooc a message"), @enactor)
          allow(@client).to receive(:room) { room }
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { true }
          expect(PoseFormatter).to receive(:format).with("Bob", "a message") { "OOC Bob a message"}
          expect(Scenes).to receive(:emit_pose).with(@enactor, "OOC Bob a message", false, true)
          @handler.handle
        end
        
        it "should emit an ooc pose" do
          room = double
          @handler = PoseCmd.new(@client, Command.new("ooc :a message"), @enactor)
          allow(@client).to receive(:room) { room }
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { true }
          expect(PoseFormatter).to receive(:format).with("Bob", ":a message") { "OOC Bob sends a message"}
          expect(Scenes).to receive(:emit_pose).with(@enactor, "OOC Bob sends a message", false, true)
          @handler.handle
        end
        
        it "should not emit if ooc chat channel eats the message" do
          room = double
          @handler = PoseCmd.new(@client, Command.new("pose a message"), @enactor)
          allow(@client).to receive(:room) { room }
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { false }
          expect(PoseFormatter).to receive(:format).with("Bob", ":a message") { "Bob a message"}
          expect(Scenes).to_not receive(:emit_pose)
          @handler.handle
        end
      end   
    end
  end
end
