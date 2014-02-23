$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe VisibleTargetFinder do
    describe :find do
      before do
        @client = double
        @client.stub(:location) { "1" }        
      end

      it "should return the char for the me keword" do
        char = double
        @client.stub(:char) { char }
        result = VisibleTargetFinder.find("me", @client)
        result.target.should eq char
        result.error.should be_nil
      end

      it "should return the char's location for the here keyword" do
        location = double
        Room.should_receive(:find_one).with("1") { location }
        result = VisibleTargetFinder.find("here", @client)
        result.target.should eq location
        result.error.should be_nil
      end

      it "should find a single item matching the name" do
        contents = 
        [
          { "name_upcase" => "A" },
          { "name_upcase" => "B" }
        ]
        ContentsFinder.should_receive(:find).with("1") { contents }
        SingleResultSelector.should_receive(:select).with([contents[0]]) { FindResult.new(contents[0], nil) }
        result = VisibleTargetFinder.find("A", @client)
        result.target.should eq contents[0]
        result.error.should be_nil
      end

      it "should fail if there are no matches" do
        contents = 
        [
          { "name_upcase" => "A" },
          { "name_upcase" => "B" }
        ]
        ContentsFinder.should_receive(:find).with("1") { contents }
        SingleResultSelector.should_receive(:select).with([]) { FindResult.new(nil, "Not found") }
        result = VisibleTargetFinder.find("C", @client)
        result.target.should eq nil
        result.error.should eq "Not found"
      end
    end
  end
end
