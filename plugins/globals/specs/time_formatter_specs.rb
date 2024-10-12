

require "aresmush"

module AresMUSH

  describe TimeFormatter do
    describe :format do
      it "should show a time less than 1 minute as seconds" do
        allow(Locale).to receive(:translate).with('time.seconds', :time => 23)  { "23s" }
        expect(TimeFormatter.format(23)).to eq "23s"
      end
      
      it "should show a time between 1m and 60m as minutes" do
        allow(Locale).to receive(:translate).with('time.minutes', :time => 2)  { "2m" }
        expect(TimeFormatter.format(120)).to eq "2m"
      end
      
      it "should show a time greater than 60m as hours" do
        allow(Locale).to receive(:translate).with('time.hours', :time => 2)  { "2h" }
        expect(TimeFormatter.format(2 * 60 * 60)).to eq "2h"
      end
      
      it "should show a time greater than 24h as days" do
        allow(Locale).to receive(:translate).with('time.days', :time => 2)  { "2d" }
        expect(TimeFormatter.format(24 * 2 * 60 * 60)).to eq "2d"
      end
      
      it "should round fractional times" do
        allow(Locale).to receive(:translate).with('time.days', :time => 2)  { "2d" }
        expect(TimeFormatter.format(24 * 2.1 * 60 * 60)).to eq "2d"
      end        
    end
  end
end
