$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe Game do
    describe :master do
      it "should return the master game object" do
        model = double
        Game.stub(:[]).with(1) { model }
        Game.master.should eq model
      end
    end

  end
end