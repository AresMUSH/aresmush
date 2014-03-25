$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe AnyTargetFinder do
    describe :find do
      before do
        @client = double
        Exit.stub(:find_all_by_name_or_id) { [] }
        Room.stub(:find_all_by_name_or_id) { [] }
        Character.stub(:find_all_by_name_or_id) { [] }
      end

      it "should return the char for the me keword" do
        char = double
        @client.stub(:char) { char }
        result = AnyTargetFinder.find("me", @client)
        result.target.should eq char
        result.error.should be_nil
      end

      it "should return the char's location for the here keyword" do
        room = double
        @client.stub(:room) { room }
        result = AnyTargetFinder.find("here", @client)
        result.target.should eq room
        result.error.should be_nil
      end
      
      it "should ensure only a single result" do
        room = double
        room.stub(:id) { 1 }
        @client.stub(:room) { room }
        char1 = double
        char2 = double
        exit = double
        room = double
        Character.should_receive(:find_all_by_name_or_id).with("A") { [char1, char2] }
        Exit.should_receive(:find_all_by_name_or_id).with("A") { [exit] }
        Room.should_receive(:find_all_by_name_or_id).with("A") { [room] }
        result = FindResult.new(nil, "an error")
        SingleResultSelector.should_receive(:select).with([char1, char2, exit, room]) { result }
        AnyTargetFinder.find("A", @client).should eq result
      end

      it "should remove nil results before selecting single target" do
        room = double
        room.stub(:id) { 1 }
        @client.stub(:room) { room }
        char = double
        Character.stub(:find_all_by_name_or_id) { [char] }
        Exit.stub(:find_all_by_name_or_id) { [nil] }
        Room.stub(:find_all_by_name_or_id) { [] }
        result = FindResult.new(char, nil)
        SingleResultSelector.should_receive(:select).with([char]) { result }
        AnyTargetFinder.find("A", @client).should eq result      
      end
    end
  end
end