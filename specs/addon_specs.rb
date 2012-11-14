$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  
  
  describe Addon do
    before do
      class AddonSpecTest
        include Addon
      end
      addon = AddonSpecTest.new(nil)
      client = double(Client)
      @player = { "name" => "Bob"}
      client.stub(:player) { @player }
      @results = addon.crack(client, "test 1=2", "test (?<arg1>.+)=(?<arg2>.+)")
    end
    
    after do
      AresMUSH.send(:remove_const, :AddonSpecTest)
    end
    
    describe :crack do
      it "should return a hash of the command args" do
        @results[:arg1].should eq "1"
        @results[:arg2].should eq "2"
      end

      it "should return the original command in the hash" do
        @results[:raw].should eq "test 1=2"
      end

      it "should return the enactor in the hash" do        
        @results[:enactor].should eq @player
      end
      
    end    
  end
end