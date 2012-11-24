$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Room do
    describe :coll do 
      it "should return the players collection" do
        Room.coll.should eq :rooms
      end
    end
    
    describe :custom_model_fields do
      it "should set the uppercase name" do
        model = {"name" => "Home", "foo" => "test"}
        model = Room.custom_model_fields(model)
        model.should include( "name_upcase" => "HOME" )
      end
    end
  end
end