$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe ClassTargetFinder
  describe :find do

    include SpecHelpers

    before do
      SpecHelpers.stub_translate_for_testing
    end
    
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
end


