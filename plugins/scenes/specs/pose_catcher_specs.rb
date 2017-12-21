module AresMUSH
  module Scenes
    describe PoseCatcherCmd do
          
      before do
        @client = double
        @enactor = double
        @handler = PoseCatcherCmd.new(@client, Command.new(":test"), @enactor)
        SpecHelpers.stub_translate_for_testing
      end
            
      describe :handle do
        it "should emit to the room" do
          room = double
          @enactor.stub(:room) { room }
          @enactor.stub(:name) { "Bob" }
          PoseFormatter.should_receive(:format).with("Bob", ":test") { "Bob test"}
          Scenes.should_receive(:emit_pose).with(@enactor, "Bob test", false, false)
          @handler.handle
        end
      end
    end
  end
end
