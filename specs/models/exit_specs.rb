$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Exit do
    describe :coll do 
      it "should return the exits collection" do
        Exit.coll.should eq :exits
      end
    end
  end
end