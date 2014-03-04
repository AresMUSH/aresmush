require_relative "../../plugin_test_loader"
  
module AresMUSH
  describe Game do    
    describe :initialize_who_record do
      it "should set the initial online record" do
        SpecHelpers.connect_to_test_db
        game = Game.create
        game.online_record.should eq 0
      end
    end
    
    context "online record" do
      before do
        @game = double
        Game.stub(:master) { @game }
      end
    
      describe :online_record do
        it "should return the online record" do
          @game.stub(:online_record) { 22 }
          Game.online_record.should eq 22
        end
      end
    
      describe :online_record= do        
        it "should set the online record" do
          @game.should_receive(:online_record=).with(22)
          @game.should_receive(:save!)
          Game.online_record = 22
        end
      end
    end
  end
  
  describe Character do 
    describe :who_location do
      before do 
        @char = Character.new
      end
      
      it "should return the locationr" do
        room = double
        @char.stub(:room) { room }
        room.should_receive(:name) { "Room Name" }
        @char.who_location.should eq "Room Name"
      end
    end    
  end
end