

require "aresmush"

module AresMUSH

  describe Game do
    describe :master do
      it "should return the master game object" do
        model = double
        allow(Game).to receive(:[]).with(1) { model }
        expect(Game.master).to eq model
      end
    end

  end
end
