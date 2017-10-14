$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH
  describe AnyTargetFinder do
    describe :find do
      before do
        @client = double
        Exit.stub(:find_any_by_name) { [] }
        Room.stub(:find_any_by_name) { [] }
        Character.stub(:find_any_by_name) { [] }
        VisibleTargetFinder.stub(:find) { FindResult.new(nil, "Error") }
      end

      it "should give preference to visible targets" do
        result = FindResult.new(double, nil)
        VisibleTargetFinder.should_receive(:find).with("A", @client) { result }
        AnyTargetFinder.find("A", @client).should eq result
      end
      
      it "should ensure only a single result" do
        room = double
        room.stub(:id) { 1 }
        @client.stub(:room) { room }
        char1 = double
        char2 = double
        exit = double
        room = double
        Character.should_receive(:find_any_by_name).with("A") { [char1, char2] }
        Exit.should_receive(:find_any_by_name).with("A") { [exit] }
        Room.should_receive(:find_any_by_name).with("A") { [room] }
        result = FindResult.new(nil, "an error")
        SingleResultSelector.should_receive(:select).with([char1, char2, exit, room]) { result }
        AnyTargetFinder.find("A", @client).should eq result
      end

      it "should remove nil results before selecting single target" do
        room = double
        room.stub(:id) { 1 }
        @client.stub(:room) { room }
        char = double
        Character.stub(:find_any_by_name) { [char] }
        Exit.stub(:find_any_by_name) { [nil] }
        Room.stub(:find_any_by_name) { [] }
        result = FindResult.new(char, nil)
        SingleResultSelector.should_receive(:select).with([char]) { result }
        AnyTargetFinder.find("A", @client).should eq result      
      end
    end
  end
end