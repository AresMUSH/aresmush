$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Room do
    describe :coll do 
      it "should return the players collection" do
        Player.coll.should eq :players
      end
    end
    
    describe :set_model_fields do
      it "should set the uppercase name" do
        model = {"name" => "Home", "foo" => "test"}
        model = Player.set_model_fields(model)
        model.should include( "name_upcase" => "HOME" )
      end
    end
  end
end