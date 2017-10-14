$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe RandomColorizer do
    
    describe :random_color do
      it "should pick the first color for the first bracket of time" do
        Time.stub(:now) { Time.new(2007,11,1,15,25,10) }
        RandomColorizer.random_color.should eq "c"
      end
      
      it "should pick the second color for the second bracket of time" do
        Time.stub(:now) { Time.new(2007,11,1,15,25,20) }
        RandomColorizer.random_color.should eq "b"
      end
      
      it "should pick the third color for the second bracket of time" do
        Time.stub(:now) { Time.new(2007,11,1,15,25,40) }
        RandomColorizer.random_color.should eq "g"
      end
      
      it "should pick the last color for the fourth bracket of time" do
        Time.stub(:now) { Time.new(2007,11,1,15,25,55) }
        RandomColorizer.random_color.should eq "r"
      end      
    end
  end
end