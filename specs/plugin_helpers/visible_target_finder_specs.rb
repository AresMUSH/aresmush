$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe VisibleTargetFinder
  describe :find do
    before do
      AresMUSH::Locale.stub(:translate).with("object.me") { "me" }
      AresMUSH::Locale.stub(:translate).with("object.here") { "here" }
      @client = mock
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
      location = mock
      Room.should_receive(:find_one).with("1") { location }
      VisibleTargetFinder.find("here", @client).should eq location
    end

    it "should call ensure and notify and return the result for matching contents" do
      AresModel.should_receive(:contents).with("1") { ["A", "B"] }
      Room.should_receive(:notify_if_not_exatly_one) do |client, &block|
        client.should eq @client
        block.call
        "A"
      end
      VisibleTargetFinder.find("A", @client).should eq "A"
    end

    it "should call ensure and notify and return nil if there's no match" do
      AresModel.should_receive(:contents).with("1") { ["A", "B"] }
      Room.should_receive(:notify_if_not_exatly_one) do |client, &block|
        client.should eq @client
        block.call
        nil
      end
      VisibleTargetFinder.find("C", @client).should eq nil
    end
  end
end
