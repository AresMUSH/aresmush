$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Players do
    describe :find do
      it "should return nil if no player found" do
        # TODO
      end

      it "should return a player if found" do
        # TODO
      end

      it "should pass on search params to the db" do
        # TODO
      end
    end
    
    describe :create do
      it "should raise an error if the player already exists" do
        # TODO
      end

      it "should create the player if it doesn't already exist" do
        # TODO
      end
    end
    
  end
end