$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe ClassTargetFinder
  describe :find do

    include SpecHelpers

    before do
      SpecHelpers.stub_translate_for_testing
    end
    
    describe :find do
      it "should find the specified class by name" do
        using_test_db do
          room = Room.create(:name => "foo")      
          result = ClassTargetFinder.find("foo", Room)
          result.target.should eq room
          result.error.should be_nil
        end
      end
    
      it "should find the specified class by ID" do
        using_test_db do
          room = Room.create(:name => "foo")
          result = ClassTargetFinder.find(room.id.to_s, Room)
          result.target.should eq room
          result.error.should be_nil
        end
      end

      it "should return ambiguous if multiple results" do
        using_test_db do
          room1 = Room.create(:name => "foo")      
          room2 = Room.create(:name => "foo")      
          result = ClassTargetFinder.find("foo", Room)
          result.target.should eq nil
          result.error.should eq 'db.object_ambiguous'
        end
      end

      it "should return not found if no results" do
        using_test_db do
          result = ClassTargetFinder.find("bar", Room)
          result.target.should eq nil
          result.error.should eq 'db.object_not_found'
        end
      end
    end

    describe :with_a_character do
      before do
        @client = double
        @char = double
        @char.stub(:name) { "char name" }
      end
      
      it "should emit failure if the char doesn't exist" do
        result = FindResult.new(nil, "error msg")
        ClassTargetFinder.should_receive(:find).with("name", Character) { result }
        @client.should_receive(:emit_failure).with("error msg")
        ClassTargetFinder.with_a_character("name", @client) do |char|
          raise "Should not get here."
        end
      end
      
      it "should not call the block with the char if it doesn't exist" do
        ClassTargetFinder.stub(:find) { FindResult.new(nil, nil) }
        @client.stub(:emit_failure)
        ClassTargetFinder.with_a_character("name", @client) do |char|
          raise "Should not get here."
        end
      end
            
      it "should call the block with the char if it exists" do
        ClassTargetFinder.stub(:find) { FindResult.new(@char, nil) }
        ClassTargetFinder.with_a_character("name", @client) do |char|
          char.name.should eq "char name"
        end
      end
    end
  end
end


