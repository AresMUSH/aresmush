$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Player do
    describe :find do
      it "should return empty if no player found" do
        AresMUSH::Database.db.stub(:find) { nil }
        Player.find("name" => "Bob").should be_empty
      end

      it "should return a player if found" do
        data = { "name" => "Bob", "password" => "test" }
        AresMUSH::Database.db.stub(:find) { [data] }
        Player.find("name" => "Bob").should eq [data]
      end

      it "should pass on search params to the db" do
        AresMUSH::Database.db.should_receive(:find).with({ "name" => "Bob", "password" => "test" })
        Player.find("name" => "Bob", "password" => "test")
      end
    end
    
    describe :find_by_name do
      it "should pass on the name in uppercase to the other find method" do
        Player.should_receive(:find).with("name_upcase" => "BOB")
        Player.find_by_name("Bob")
      end
    end
    
    describe :create do
      it "should raise an error if the player already exists" do
        # TODO
      end

      it "should create the player if it doesn't already exist" do
        # TODO
      end
      
      it "should assign a database id" do
        # TODO
      end
    end    
  end
end