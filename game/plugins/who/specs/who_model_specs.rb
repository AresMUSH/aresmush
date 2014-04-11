require_relative "../../plugin_test_loader"
  
module AresMUSH
  describe Game do    
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
  
  describe Character do 
    describe :who_room_name do
      before do 
        @char = Character.new
        SpecHelpers.stub_translate_for_testing
      end
      
      it "should return the location if visible" do
        room = double
        @char.stub(:hidden) { false }
        @char.stub(:room) { room }
        room.should_receive(:name) { "Room Name" }
        @char.who_room_name.should eq "Room Name"
      end
      
      it "should return unfindable if hidden" do
        @char.stub(:hidden) { true }
        @char.who_room_name.should eq "who.hidden"
      end
    end    
  end
end