$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH
  describe VisibleTargetFinder do
    describe :find do
      before do
        @char = double
        allow(Exit).to receive(:where) { [] }
        allow(Character).to receive(:where) { [] }
        stub_translate_for_testing
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
            
      describe :single_target do
        before do
          @room = double
          @char1 = double
          @char2 = double
          @exit = double
          
          allow(@char1).to receive(:room) { @room }
          allow(@room).to receive(:exits) { [@exit] }
          allow(@room).to receive(:characters) { [@char1, @char2] }
        end
        
        it "should ensure only a single result" do
          result = FindResult.new(nil, "An error")
          
          allow(@room).to receive(:name_upcase) { "CAR PARK" }
          allow(@char1).to receive(:name_upcase) { "CAL" }
          allow(@char2).to receive(:name_upcase) { "CALIFORNIA" }
          allow(@exit).to receive(:name_upcase) { "CA" }
          
          expect(SingleResultSelector).to receive(:select).with([@char1, @char2, @exit]) { result }
          expect(VisibleTargetFinder.find("C", @char1)).to eq result      
        end
        
        it "should match an exit name" do
          result = FindResult.new(nil, "An error")
          
          allow(@room).to receive(:name_upcase) { "PARK" }
          allow(@char1).to receive(:name_upcase) { "ELI" }
          allow(@char2).to receive(:name_upcase) { "TORRES" }
          allow(@exit).to receive(:name_upcase) { "CA" }
          
          result = VisibleTargetFinder.find("Ca", @char1)
          expect(result.target).to eq @exit
        end
        
        it "should match a char name" do
          result = FindResult.new(nil, "An error")
          
          allow(@room).to receive(:name_upcase) { "CAR PARK" }
          allow(@char1).to receive(:name_upcase) { "ELI" }
          allow(@char2).to receive(:name_upcase) { "TORRES" }
          allow(@exit).to receive(:name_upcase) { "CA" }
          
          result = VisibleTargetFinder.find("Eli", @char1)
          expect(result.target).to eq @char1
        end
        
        it "should match the char's room name" do
          allow(@room).to receive(:name_upcase) { "PARK" }
          allow(@char1).to receive(:name_upcase) { "ELI" }
          allow(@char2).to receive(:name_upcase) { "TORRES" }
          allow(@exit).to receive(:name_upcase) { "CA" }
          
          result = VisibleTargetFinder.find("Park", @char1)
          expect(result.target).to eq @room
          expect(result.error).to be_nil
        end
        
        it "should pick an exact match over a partial one with char" do
          result = FindResult.new(nil, "An error")
          
          allow(@room).to receive(:name_upcase) { "CAR PARK" }
          allow(@char1).to receive(:name_upcase) { "CAL" }
          allow(@char2).to receive(:name_upcase) { "CALIFORNIA" }
          allow(@exit).to receive(:name_upcase) { "CA" }
          
          expect(SingleResultSelector).to receive(:select).with([@char1]) { result }
          expect(VisibleTargetFinder.find("CAL", @char1)).to eq result      
        end
        
        it "should pick an exact match over a partial one with exit" do
          result = FindResult.new(nil, "An error")
          
          allow(@room).to receive(:name_upcase) { "CAR PARK" }
          allow(@char1).to receive(:name_upcase) { "CAL" }
          allow(@char2).to receive(:name_upcase) { "CALIFORNIA" }
          allow(@exit).to receive(:name_upcase) { "CA" }
          
          expect(SingleResultSelector).to receive(:select).with([@exit]) { result }
          expect(VisibleTargetFinder.find("CA", @char1)).to eq result      
        end
        
        it "should pick an exact match over a partial one with a room" do
          result = FindResult.new(nil, "An error")
          
          allow(@room).to receive(:name_upcase) { "CA" }
          allow(@char1).to receive(:name_upcase) { "CAL" }
          allow(@char2).to receive(:name_upcase) { "CALIFORNIA" }
          allow(@exit).to receive(:name_upcase) { "CAR" }
          
          expect(SingleResultSelector).to receive(:select).with([@room]) { result }
          expect(VisibleTargetFinder.find("CA", @char1)).to eq result      
        end
        
      end
    end
    
    describe :with_something_visible do
      before do
        @client = double
        @object = double
        allow(@object).to receive(:name_upcase) { "OBJ NAME" }
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
          expect(@object.name_upcase).to eq "OBJ NAME"
        end
      end
    end
  end
end
