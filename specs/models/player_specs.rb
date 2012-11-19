$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Player do
    describe :find do
      it "should return empty if no player found" do
        Database.db.stub(:find) { nil }
        Player.find("name" => "Bob").should be_empty
      end

      it "should return a player if found" do
        data = { "name" => "Bob", "password" => "test" }
        Database.db.stub(:find) { [data] }
        Player.find("name" => "Bob").should eq [data]
      end

      it "should pass on search params to the db" do
        Database.db.should_receive(:find).with({ "name" => "Bob", "password" => "test" })
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
      before do
        @tmpdb = double(Object)
        Database.db.stub(:[]).with(:players) { @tmpdb }
      end
      
      it "should create the player" do
        @tmpdb.should_receive(:insert) do |player|
          player["name"].should eq "Bob"
          player["password"].should eq "test"
          player["name_upcase"].should eq "BOB"
        end
        Player.create("Bob", "test")
      end
      
      it "should store the fields, including the database id, on the returned object" do
        @tmpdb.stub(:insert) { 123 }
        Player.create("Bob", "test") do |player|
          player["name"].should eq "Bob"
          player["password"].should eq "test"
          player["name_upcase"].should eq "BOB"
          player["id"].should eq 123
        end        
      end      
    end    
  end
end