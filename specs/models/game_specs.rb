$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Game do
    describe :get do
      it "should return the game object" do
        model = double
        Database.db.stub(:find) { [model] }
        Game.get.should eq model
      end
    end

    describe :create do
      it "should create and return the game object" do
        tmpdb = double
        Database.db.stub(:[]).with(:game) { tmpdb }
        tmpdb.stub(:insert)
        Game.create do |model|
          model.class.should eq Hash
          model.empty?.should be_true
        end        
      end            
    end  

    describe :update do
      it "should update by id" do
        tmpdb = double
        Database.db.stub(:[]).with(:game) { tmpdb }
        p = { "_id" => "123", "name" => "Bob" }
        tmpdb.should_receive(:update) do |search, model|
          search["_id"].should eq "123"
          model.should eq p
        end
        Game.update(p)
      end
    end

    describe :drop_all do
      it "should drop the DB" do
        tmpdb = double
        Database.db.stub(:[]).with(:game) { tmpdb }
        tmpdb.should_receive(:drop) 
        Game.drop_all
      end
    end
  end
end