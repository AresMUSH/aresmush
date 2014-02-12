require_relative "../../plugin_test_loader"
  
module AresMUSH
  describe Game do
    before do
      MongoMapper::Plugins::Querying.stub(:save_to_collection) {}
    end

    describe :initialize_who_record do
      it "should set the initial online record" do
        SpecHelpers.connect_to_test_db
        game = Game.create
        game.online_record.should eq 0
      end
    end
  end
end