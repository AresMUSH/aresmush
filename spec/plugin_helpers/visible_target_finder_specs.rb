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
      
      it "should return the char's location if the name matches the room name" do
        room = double
        expect(room).to receive(:name) { "My Room" }
        allow(@char).to receive(:room) { room }
        result = VisibleTargetFinder.find("My Room", @char)
        expect(result.target).to eq room
        expect(result.error).to be_nil
      end
      
      it "should return the char's location if the name matches the room name" do
        room = double
        expect(room).to receive(:name) { "My Room" }
        allow(@char).to receive(:room) { room }
        result = VisibleTargetFinder.find("My", @char)
        expect(result.target).to eq room
        expect(result.error).to be_nil
      end
      
      describe :single_target do
        before do
          @room = double
          @char1 = double
          @char2 = double
          @exit = double
          
          allow(@room).to receive(:name) { "My Room" }
          expect(@char1).to receive(:room) { @room }
          expect(@room).to receive(:exits) { [@exit] }
          expect(@room).to receive(:characters) { [@char1, @char2] }
        end
        
        it "should ensure only a single result" do
          result = FindResult.new(nil, "An error")
          
          allow(@char1).to receive(:name) { "Cal" }
          allow(@char2).to receive(:name) { "California" }
          allow(@exit).to receive(:name) { "CA" }
          
          expect(SingleResultSelector).to receive(:select).with([@char1, @char2, @exit]) { result }
          expect(VisibleTargetFinder.find("Ca", @char1)).to eq result      
        end
        
        it "should match an exit name" do
          result = FindResult.new(nil, "An error")
          
          allow(@char1).to receive(:name) { "Eli" }
          allow(@char2).to receive(:name) { "Torres" }
          allow(@exit).to receive(:name) { "CA" }
          
          result = VisibleTargetFinder.find("Ca", @char1)
          expect(result.target).to eq @exit
        end
        
        it "should match a char name" do
          result = FindResult.new(nil, "An error")
          
          allow(@char1).to receive(:name) { "Eli" }
          allow(@char2).to receive(:name) { "Torres" }
          allow(@exit).to receive(:name) { "CA" }
          
          result = VisibleTargetFinder.find("Eli", @char1)
          expect(result.target).to eq @char1
        end

        
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
