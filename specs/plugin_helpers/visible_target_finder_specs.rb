$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe VisibleTargetFinder do
    describe :find do
      before do
        AresMUSH::Locale.stub(:translate).with("object.me") { "me" }
        AresMUSH::Locale.stub(:translate).with("object.here") { "here" }
        @client = double
        @client.stub(:location) { "1" }        
      end

      it "should return the char for the me keword" do
        @client.stub(:char) { @char }
        VisibleTargetFinder.find("me", @client).should eq @char
      end

      it "should use the default when no target is specified" do
        @client.stub(:char) { @char }
        VisibleTargetFinder.find(nil, @client, "me").should eq @char
      end

      it "should return the char's location for the here keyword" do
        location = double
        Room.should_receive(:find_one).with("1") { location }
        VisibleTargetFinder.find("here", @client).should eq location
      end

      it "should find a single item matching the name" do
        contents = 
        [
          { "name_upcase" => "A" },
          { "name_upcase" => "B" }
        ]
        ContentsFinder.should_receive(:find).with("1") { contents }
        SingleResultSelector.should_receive(:select).with([contents[0]], @client) { contents[0] }
        VisibleTargetFinder.find("A", @client).should eq contents[0]
      end

      it "should return nil if there are no matches" do
        contents = 
        [
          { "name_upcase" => "A" },
          { "name_upcase" => "B" }
        ]
        ContentsFinder.should_receive(:find).with("1") { contents }
        SingleResultSelector.should_receive(:select).with([], @client) { nil }
        VisibleTargetFinder.find("C", @client).should eq nil
      end
    end
  end
end
