require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe Who do
      before do
        @game = double
        Game.stub(:master) { @game }
      end

      describe :online_record do
        it "should return the online record" do
          @game.stub(:online_record) { 22 }
          Who.online_record.should eq 22
        end
      end
      
      describe :online_record= do        
        it "should set the online record" do
          @game.should_receive(:online_record=).with(22)
          @game.should_receive(:save!)
          Who.online_record = 22
        end
      end
    end
  end
end