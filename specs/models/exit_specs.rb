$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Exit do
    describe :coll do 
      it "should return the exits collection" do
        Exit.coll.should eq :exits
      end
    end
    
    describe :custom_model_fields do
      it "should set the object type" do
        model = {"name" => "Home", "foo" => "test"}
        model = Room.custom_model_fields(model)
        model.should include( "type" => "Room" )
      end
    end
    
    
  end
end