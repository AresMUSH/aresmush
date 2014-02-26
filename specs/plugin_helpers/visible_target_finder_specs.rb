$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe VisibleTargetFinder do
    describe :find do
      before do
        @client = double
      end

      it "should return the char for the me keword" do
        char = double
        @client.stub(:char) { char }
        result = VisibleTargetFinder.find("me", @client)
        result.target.should eq char
        result.error.should be_nil
      end

      it "should return the char's location for the here keyword" do
        room = double
        @client.stub(:room) { room }
        result = VisibleTargetFinder.find("here", @client)
        result.target.should eq room
        result.error.should be_nil
      end

      it "should search for matching characters" do
        room = double
        room.stub(:id) { 1 }
        @client.stub(:room) { room }
        Character.should_receive(:find_by_room_id_and_name).with(1, "A") { [double] }
        Exit.stub(:find_by_source_id_and_name) { [] }
        VisibleTargetFinder.find("A", @client)
      end
      
      it "should serch for matching exits" do 
        room = double
        room.stub(:id) { 1 }
        @client.stub(:room) { room }
        Character.stub(:find_by_room_id_and_name) { [] }
        Exit.should_receive(:find_by_source_id_and_name).with(1, "A") { [double] }
        VisibleTargetFinder.find("A", @client)
      end
      
      it "should ensure only a single result" do
        room = double
        room.stub(:id) { 1 }
        @client.stub(:room) { room }
        char1 = double
        char2 = double
        exit = double
        Character.stub(:find_by_room_id_and_name) { [char1, char2] }
        Exit.stub(:find_by_source_id_and_name) { [exit] }
        result = FindResult.new(nil, "an error")
        SingleResultSelector.should_receive(:select).with([char1, char2, exit]) { result }
        VisibleTargetFinder.find("A", @client).should eq result      
      end

      it "should remove nil results before selecting single target" do
        room = double
        room.stub(:id) { 1 }
        @client.stub(:room) { room }
        char = double
        Character.stub(:find_by_room_id_and_name) { [char] }
        Exit.stub(:find_by_source_id_and_name) { [nil] }
        result = FindResult.new(char, nil)
        SingleResultSelector.should_receive(:select).with([char]) { result }
        VisibleTargetFinder.find("A", @client).should eq result      
      end
    end
  end
end