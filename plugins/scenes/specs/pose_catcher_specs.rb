module AresMUSH
  module Scenes
    describe PoseCatcherCmd do
          
      before do
        @client = double
        @enactor = double
        @handler = PoseCatcherCmd.new(@client, Command.new(":test"), @enactor)
        allow(@enactor).to receive(:ooc_name) { "Bob OOC" }
        stub_translate_for_testing
      end
            
      describe :handle do
        it "should emit to the room" do
          room = double
          allow(@enactor).to receive(:room) { room }
          allow(@enactor).to receive(:name) { "Bob" }
          allow(Places).to receive(:reset_place_if_moved)
          expect(PoseFormatter).to receive(:format).with("Bob", ":test") { "Bob test"}
          expect(PoseFormatter).to receive(:format).with("Bob OOC", ":test") { "Bob OOC test"}
          expect(Scenes).to receive(:emit_pose).with(@enactor, "Bob test", false, false)
          @handler.handle
        end
      end
    end
  end
end
