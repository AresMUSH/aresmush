$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH
  describe ClassTargetFinder do
  
    describe :find do

      include SpecHelpers

      before do
        SpecHelpers.stub_translate_for_testing
      end
    
      describe :find do
        before do
          @viewer = double
        end
        
        it "should find the specified class by name" do
          room = double
          Room.stub(:find_any_by_name).with("foo") { [room] }
          result = ClassTargetFinder.find("foo", Room, @viewer)
          result.target.should eq room
          result.error.should be_nil
        end
    
        it "should return ambiguous if multiple results" do
          Room.stub(:find_any_by_name).with("foo") { [double, double] }
          result = ClassTargetFinder.find("foo", Room, @viewer)
          result.target.should eq nil
          result.error.should eq 'db.object_ambiguous'
        end

        it "should return not found if no results" do
          Room.stub(:find_any_by_name).with("bar") { [] }
          result = ClassTargetFinder.find("bar", Room, @viewer)
          result.target.should eq nil
          result.error.should eq 'db.object_not_found'
        end
      
        it "should return the char for the me keword" do
          result = ClassTargetFinder.find("me", Character, @viewer)
          result.target.should eq @viewer
          result.error.should be_nil
        end

        it "should not return the char for another kind of object" do
          char = double
          @viewer.stub(:char) { char }
          Room.stub(:find_any_by_name).with("me") { [] }
          result = ClassTargetFinder.find("me", Room, @viewer)
          result.target.should eq nil
          result.error.should eq 'db.object_not_found'
        end
      
        it "should return the char's location for the here keyword" do
          room = double
          @viewer.stub(:room) { room }
          result = ClassTargetFinder.find("here", Room, @viewer)
          result.target.should eq room
          result.error.should be_nil
        end
      
        it "should not find here for another kind of object" do
          room = double
          @viewer.stub(:room) { room }
          Character.stub(:find_any_by_name).with("here") { [] }
          result = ClassTargetFinder.find("here", Character, @viewer)
          result.target.should eq nil
          result.error.should eq 'db.object_not_found'
        end
      end

      describe :with_a_character do
        before do
          @viewer = double
          @client = double
          @char = double
          @char.stub(:name) { "char name" }
        end
      
        it "should emit failure if the char doesn't exist" do
          result = FindResult.new(nil, "error msg")
          ClassTargetFinder.should_receive(:find).with("name", Character, @viewer) { result }
          @client.should_receive(:emit_failure).with("error msg")
          ClassTargetFinder.with_a_character("name", @client, @viewer) do |char|
            raise "Should not get here."
          end
        end
      
        it "should not call the block with the char if it doesn't exist" do
          ClassTargetFinder.stub(:find) { FindResult.new(nil, nil) }
          @client.stub(:emit_failure)
          ClassTargetFinder.with_a_character("name", @client, @viewer) do |char|
            raise "Should not get here."
          end
        end
            
        it "should call the block with the char if it exists" do
          ClassTargetFinder.stub(:find) { FindResult.new(@char, nil) }
          ClassTargetFinder.with_a_character("name", @client, @viewer) do |char|
            char.name.should eq "char name"
          end
        end
      end
    end
  end
end