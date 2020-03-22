module AresMUSH
  module Scenes
    describe PoseCatcherCmd do
          
      before do
        @client = double
        @enactor = double
        stub_translate_for_testing
      end
            
      describe :handle do
        it "should emit a say" do
          room = double
          @handler = PoseCatcherCmd.new(@client, Command.new("\"test"), @enactor)
          allow(@enactor).to receive(:room) { room }
          allow(@enactor).to receive(:name) { "Bob" }
          expect(PoseFormatter).to receive(:format).with("Bob", "\"test") { "Bob test"}
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { true }
          expect(Scenes).to receive(:emit_pose).with(@enactor, "Bob test", false, false)
          @handler.handle
        end

        it "should emit a pose" do
          room = double
          @handler = PoseCatcherCmd.new(@client, Command.new(":test"), @enactor)
          allow(@enactor).to receive(:room) { room }
          allow(@enactor).to receive(:name) { "Bob" }
          expect(PoseFormatter).to receive(:format).with("Bob", ":test") { "Bob test"}
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { true }
          expect(Scenes).to receive(:emit_pose).with(@enactor, "Bob test", false, false)
          @handler.handle
        end
        
        it "should emit a semipose" do
          room = double
          @handler = PoseCatcherCmd.new(@client, Command.new(";test"), @enactor)
          allow(@enactor).to receive(:room) { room }
          allow(@enactor).to receive(:name) { "Bob" }
          expect(PoseFormatter).to receive(:format).with("Bob", ";test") { "Bob test"}
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { true }
          expect(Scenes).to receive(:emit_pose).with(@enactor, "Bob test", false, false)
          @handler.handle
        end
        
        it "should emit an emit with backslashes" do
          room = double
          @handler = PoseCatcherCmd.new(@client, Command.new("\\test"), @enactor)
          allow(@enactor).to receive(:room) { room }
          allow(@enactor).to receive(:name) { "Bob" }
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { true }
          expect(Scenes).to receive(:emit_pose).with(@enactor, "test", true, false)
          @handler.handle
        end
        
        it "should emit an emit with double backslashes" do
          room = double
          @handler = PoseCatcherCmd.new(@client, Command.new("\\\\test"), @enactor)
          allow(@enactor).to receive(:room) { room }
          allow(@enactor).to receive(:name) { "Bob" }
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { true }
          expect(Scenes).to receive(:emit_pose).with(@enactor, "test", true, false)
          @handler.handle
        end
        
        it "should emit an ooc with an angle bracket" do
          room = double
          @handler = PoseCatcherCmd.new(@client, Command.new(">test"), @enactor)
          allow(@enactor).to receive(:room) { room }
          allow(@enactor).to receive(:name) { "Bob" }
          expect(PoseFormatter).to receive(:format).with("Bob", "test") { "Bob test"}
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { true }
          expect(Scenes).to receive(:emit_pose).with(@enactor, "Bob test", false, true)
          @handler.handle
        end
        
        it "should emit an ooc with a single quote" do
          room = double
          @handler = PoseCatcherCmd.new(@client, Command.new("'test"), @enactor)
          allow(@enactor).to receive(:room) { room }
          allow(@enactor).to receive(:name) { "Bob" }
          expect(PoseFormatter).to receive(:format).with("Bob", "test") { "Bob test"}
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { true }
          expect(Scenes).to receive(:emit_pose).with(@enactor, "Bob test", false, true)
          @handler.handle
        end
        
        it "should not emit if ooc chat channel eats the message" do
          room = double
          @handler = PoseCatcherCmd.new(@client, Command.new("test"), @enactor)
          allow(@enactor).to receive(:room) { room }
          allow(@enactor).to receive(:name) { "Bob" }
          expect(PoseFormatter).to receive(:format).with("Bob", "test") { "Bob test"}
          expect(Scenes).to receive(:send_to_ooc_chat_if_needed) { false }
          expect(Scenes).to_not receive(:emit_pose)
          @handler.handle
        end
        
      end
    end
  end
end
