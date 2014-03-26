$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe TimeFormatter do
    describe :format do
      it "should show a time less than 1 minute as seconds" do
        Locale.stub(:translate).with('time.seconds', :time => 23)  { "23s" }
        TimeFormatter.format(23).should eq "23s"
      end
      
      it "should show a time between 1m and 60m as minutes" do
        Locale.stub(:translate).with('time.minutes', :time => 2)  { "2m" }
        TimeFormatter.format(120).should eq "2m"
      end
      
      it "should show a time greater than 60m as hours" do
        Locale.stub(:translate).with('time.hours', :time => 61)  { "61h" }
        TimeFormatter.format(61 * 60 * 60).should eq "61h"
      end
    end
  end
end