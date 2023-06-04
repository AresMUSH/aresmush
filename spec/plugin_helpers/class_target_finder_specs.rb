

require "aresmush"

module AresMUSH
  describe ClassTargetFinder do
  
    describe :find do

      include SpecHelpers

      before do
        stub_translate_for_testing
      end
    
      describe :find do
        before do
          @viewer = double
        end
        
        it "should find the specified class by name" do
          room = double
          allow(Room).to receive(:find_any_by_name).with("foo") { [room] }
          result = ClassTargetFinder.find("foo", Room, @viewer)
          expect(result.target).to eq room
          expect(result.error).to be_nil
        end
    
        it "should return ambiguous if multiple results" do
          allow(Room).to receive(:find_any_by_name).with("foo") { [double, double] }
          result = ClassTargetFinder.find("foo", Room, @viewer)
          expect(result.target).to eq nil
          expect(result.error).to eq 'db.object_ambiguous'
        end

        it "should return not found if no results" do
          allow(Room).to receive(:find_any_by_name).with("bar") { [] }
          result = ClassTargetFinder.find("bar", Room, @viewer)
          expect(result.target).to eq nil
          expect(result.error).to eq 'db.object_not_found'
        end
      
        it "should return the char for the me keword" do
          result = ClassTargetFinder.find("me", Character, @viewer)
          expect(result.target).to eq @viewer
          expect(result.error).to be_nil
        end

        it "should not return the char for another kind of object" do
          char = double
          allow(@viewer).to receive(:char) { char }
          allow(Room).to receive(:find_any_by_name).with("me") { [] }
          result = ClassTargetFinder.find("me", Room, @viewer)
          expect(result.target).to eq nil
          expect(result.error).to eq 'db.object_not_found'
        end
      
        it "should return the char's location for the here keyword" do
          room = double
          allow(@viewer).to receive(:room) { room }
          result = ClassTargetFinder.find("here", Room, @viewer)
          expect(result.target).to eq room
          expect(result.error).to be_nil
        end
      
        it "should not find here for another kind of object" do
          room = double
          allow(@viewer).to receive(:room) { room }
          allow(Character).to receive(:find_any_by_name).with("here") { [] }
          result = ClassTargetFinder.find("here", Character, @viewer)
          expect(result.target).to eq nil
          expect(result.error).to eq 'db.object_not_found'
        end
      end

      describe :with_a_character do
        before do
          @viewer = double
          @client = double
          @char = double
          allow(@char).to receive(:name) { "char name" }
        end
      
        it "should emit failure if the char doesn't exist" do
          result = FindResult.new(nil, "error msg")
          expect(ClassTargetFinder).to receive(:find).with("name", Character, @viewer) { result }
          expect(@client).to receive(:emit_failure).with("error msg")
          ClassTargetFinder.with_a_character("name", @client, @viewer) do |char|
            raise "Should not get here."
          end
        end
      
        it "should not call the block with the char if it doesn't exist" do
          allow(ClassTargetFinder).to receive(:find) { FindResult.new(nil, nil) }
          allow(@client).to receive(:emit_failure)
          ClassTargetFinder.with_a_character("name", @client, @viewer) do |char|
            raise "Should not get here."
          end
        end
            
        it "should call the block with the char if it exists" do
          allow(ClassTargetFinder).to receive(:find) { FindResult.new(@char, nil) }
          ClassTargetFinder.with_a_character("name", @client, @viewer) do |char|
            expect(char.name).to eq "char name"
          end
        end
      end
    end
  end
end
