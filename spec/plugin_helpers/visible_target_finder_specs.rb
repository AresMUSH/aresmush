$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH
  describe VisibleTargetFinder do
    describe :find do
      before do
        @char = double
        allow(Exit).to receive(:where) { [] }
        allow(Character).to receive(:where) { [] }
      end

      it "should return the char for the me keword" do
        result = VisibleTargetFinder.find("me", @char)
        expect(result.target).to eq @char
        expect(result.error).to be_nil
      end

      it "should return the char's location for the here keyword" do
        room = double
        allow(@char).to receive(:room) { room }
        result = VisibleTargetFinder.find("here", @char)
        expect(result.target).to eq room
        expect(result.error).to be_nil
      end
      
      it "should ensure only a single result" do
        room = double
        allow(room).to receive(:id) { 1 }
        allow(@char).to receive(:room) { room }
        char1 = double
        char2 = double
        exit = double
        allow(char1).to receive(:room) { room }
        allow(char2).to receive(:room) { room }
        allow(exit).to receive(:source) { room }
        expect(Character).to receive(:find_any_by_name).with("A") { [char1, char2] }
        expect(Exit).to receive(:find_any_by_name).with("A") { [exit] }
        result = FindResult.new(nil, "an error")
        expect(SingleResultSelector).to receive(:select).with([char1, char2, exit]) { result }
        expect(VisibleTargetFinder.find("A", @char)).to eq result      
      end

      it "should remove nil results before selecting single target" do
        room = double
        allow(room).to receive(:id) { 1 }
        allow(@char).to receive(:room) { room }
        char1 = double
        allow(char1).to receive(:room) { room }
        allow(Character).to receive(:find_any_by_name) { [char1] }
        allow(Exit).to receive(:find_any_by_name) { [] }
        result = FindResult.new(char1, nil)
        expect(SingleResultSelector).to receive(:select).with([char1]) { result }
        expect(VisibleTargetFinder.find("A", @char)).to eq result      
      end
    end
    
    describe :with_something_visible do
      before do
        @client = double
        @object = double
        allow(@object).to receive(:name) { "obj name" }
      end
      
      it "should emit failure if the object isn't visible" do
        result = FindResult.new(nil, "error msg")
        expect(VisibleTargetFinder).to receive(:find).with("name", @char) { result }
        expect(@client).to receive(:emit_failure).with("error msg")
        VisibleTargetFinder.with_something_visible("name", @client, @char) do |obj|
          raise "Should not get here."
        end
      end
      
      it "should not call the block with the object if it doesn't exist" do
        allow(VisibleTargetFinder).to receive(:find) { FindResult.new(nil, nil) }
        allow(@client).to receive(:emit_failure)
        VisibleTargetFinder.with_something_visible("name", @client, @char) do |obj|
          raise "Should not get here."
        end
      end
            
      it "should call the block with the char if it exists" do
        allow(VisibleTargetFinder).to receive(:find) { FindResult.new(@object, nil) }
        VisibleTargetFinder.with_something_visible("name", @client, @char) do |obj|
          expect(@object.name).to eq "obj name"
        end
      end
    end
  end
end
