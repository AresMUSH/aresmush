$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Room do
    describe :find do
      it "should return empty if no room found" do
        Database.db.stub(:find) { nil }
        Room.find("name" => "Home").should be_empty
      end

      it "should return a room if found" do
        data = { "name" => "Home" }
        Database.db.stub(:find) { [data] }
        Room.find("name" => "Home").should eq [data]
      end

      it "should pass on search params to the db" do
        Database.db.should_receive(:find).with({ "name" => "Home", "zone" => "Foo" })
        Room.find("name" => "Home", "zone" => "Foo")
      end
    end
    
    describe :find_by_id do
      it "should pass on a BSON object id" do
        id = BSON::ObjectId.new("123")
        Room.should_receive(:find).with("_id" => id)
        Room.find_by_id(id)
      end
      
      it "should wrap a numeric string into a BSON id" do
        Room.should_receive(:find).with("_id" => BSON::ObjectId("50a630bbbd02862ead000001"))
        Room.find_by_id("50a630bbbd02862ead000001")
      end
      
      it "should return nothing if given an invalid id" do
        Room.find_by_id("id").should eq []
      end
    end
    
    describe :create do
      before do
        @tmpdb = double(Object)
        Database.db.stub(:[]).with(:rooms) { @tmpdb }
      end
      
      it "should create the room" do
        @tmpdb.should_receive(:insert) do |room|
          room["name"].should eq "Home"
        end
        Room.create("Home")
      end
      
      it "should return the inserted object" do
        @tmpdb.stub(:insert)
        Room.create("Home") do |room|
          room["name"].should eq "Home"
        end        
      end      
    end    
  end
end