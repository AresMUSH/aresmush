

require "aresmush"

module AresMUSH

  describe RandomColorizer do
    
    describe :random_color do
      it "should pick the first color for the first bracket of time" do
        allow(Time).to receive(:now) { Time.new(2007,11,1,15,25,10) }
        expect(RandomColorizer.random_color).to eq "%xc"
      end
      
      it "should pick the second color for the second bracket of time" do
        allow(Time).to receive(:now) { Time.new(2007,11,1,15,25,20) }
        expect(RandomColorizer.random_color).to eq "%xb"
      end
      
      it "should pick the third color for the second bracket of time" do
        allow(Time).to receive(:now) { Time.new(2007,11,1,15,25,40) }
        expect(RandomColorizer.random_color).to eq "%xg"
      end
      
      it "should pick the last color for the fourth bracket of time" do
        allow(Time).to receive(:now) { Time.new(2007,11,1,15,25,55) }
        expect(RandomColorizer.random_color).to eq "%xr"
      end      
    end
  end
end
