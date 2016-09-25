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
        Locale.stub(:translate).with('time.hours', :time => 2)  { "2h" }
        TimeFormatter.format(2 * 60 * 60).should eq "2h"
      end
      
      it "should show a time greater than 24h as days" do
        Locale.stub(:translate).with('time.days', :time => 2)  { "2d" }
        TimeFormatter.format(24 * 2 * 60 * 60).should eq "2d"
      end
      
      it "should round fractional times" do
        Locale.stub(:translate).with('time.days', :time => 2)  { "2d" }
        TimeFormatter.format(24 * 2.1 * 60 * 60).should eq "2d"
      end        
    end
  end
end