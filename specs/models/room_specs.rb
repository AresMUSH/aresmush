$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Room do
    describe :coll do 
      it "should return the rooms collection" do
        Room.coll.should eq :rooms
      end
    end
    
    describe :custom_model_fields do
      it "should set the uppercase name" do
        model = {"name" => "Home", "foo" => "test"}
        model = Room.custom_model_fields(model)
        model.should include( "name_upcase" => "HOME" )
      end

      it "should set the object type" do
        model = {"name" => "Home", "foo" => "test"}
        model = Room.custom_model_fields(model)
        model.should include( "type" => "Room" )
      end
    end
  end
end