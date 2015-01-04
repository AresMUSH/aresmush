require_relative "../../plugin_test_loader"
  
module AresMUSH
  describe Game, :dbtest => true do    
    describe :initialize_who_record do
      it "should set the initial online record" do
        using_test_db do
          game = Game.create
          game.online_record.should eq 0
        end
      end
    end
    
    context "online record" do
      describe :online_record do
        it "should return the online record" do
          using_test_db do
            game = Game.create
            game.online_record = 22            
            game.save!
            Game.master.online_record.should eq 22
          end
        end
      end
    end
  end
end