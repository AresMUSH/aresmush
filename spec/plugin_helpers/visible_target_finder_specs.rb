$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH
  describe VisibleTargetFinder do
    describe :find do
      before do
        @char = double
        Exit.stub(:where) { [] }
        Character.stub(:where) { [] }
      end

      it "should return the char for the me keword" do
        result = VisibleTargetFinder.find("me", @char)
        result.target.should eq @char
        result.error.should be_nil
      end

      it "should return the char's location for the here keyword" do
        room = double
        @char.stub(:room) { room }
        result = VisibleTargetFinder.find("here", @char)
        result.target.should eq room
        result.error.should be_nil
      end
      
      it "should ensure only a single result" do
        room = double
        room.stub(:id) { 1 }
        @char.stub(:room) { room }
        char1 = double
        char2 = double
        exit = double
        char1.stub(:room) { room }
        char2.stub(:room) { room }
        exit.stub(:source) { room }
        Character.should_receive(:find_any_by_name).with("A") { [char1, char2] }
        Exit.should_receive(:find_any_by_name).with("A") { [exit] }
        result = FindResult.new(nil, "an error")
        SingleResultSelector.should_receive(:select).with([char1, char2, exit]) { result }
        VisibleTargetFinder.find("A", @char).should eq result      
      end

      it "should remove nil results before selecting single target" do
        room = double
        room.stub(:id) { 1 }
        @char.stub(:room) { room }
        char1 = double
        char1.stub(:room) { room }
        Character.stub(:find_any_by_name) { [char1] }
        Exit.stub(:find_any_by_name) { [] }
        result = FindResult.new(char1, nil)
        SingleResultSelector.should_receive(:select).with([char1]) { result }
        VisibleTargetFinder.find("A", @char).should eq result      
      end
    end
    
    describe :with_something_visible do
      before do
        @client = double
        @object = double
        @object.stub(:name) { "obj name" }
      end
      
      it "should emit failure if the object isn't visible" do
        result = FindResult.new(nil, "error msg")
        VisibleTargetFinder.should_receive(:find).with("name", @char) { result }
        @client.should_receive(:emit_failure).with("error msg")
        VisibleTargetFinder.with_something_visible("name", @client, @char) do |obj|
          raise "Should not get here."
        end
      end
      
      it "should not call the block with the object if it doesn't exist" do
        VisibleTargetFinder.stub(:find) { FindResult.new(nil, nil) }
        @client.stub(:emit_failure)
        VisibleTargetFinder.with_something_visible("name", @client, @char) do |obj|
          raise "Should not get here."
        end
      end
            
      it "should call the block with the char if it exists" do
        VisibleTargetFinder.stub(:find) { FindResult.new(@object, nil) }
        VisibleTargetFinder.with_something_visible("name", @client, @char) do |obj|
          @object.name.should eq "obj name"
        end
      end
    end
  end
end