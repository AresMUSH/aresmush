$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe OnlineCharFinder do
    describe :find do
      before do
        @client = double
        @client_monitor = double
        Global.stub(:client_monitor) { @client_monitor }
        SpecHelpers.stub_translate_for_testing
      end

      it "should return the client for the me keword" do
        char = double
        result = OnlineCharFinder.find("me", @client)
        result.target.should eq @client
        result.error.should be_nil
      end

      it "should return a matching online char" do
        client1 = double
        client2 = double
        client1.stub(:name) { "Harvey" }
        client2.stub(:name) { "Bob" }
        @client_monitor.stub(:clients) { [client1, client2 ]}
        result = OnlineCharFinder.find("bo", @client)
        result.target.should eq client2
        result.error.should be_nil
      end
      
      it "should ensure only a single result" do
        client1 = double
        client2 = double
        client1.stub(:name) { "Anne" }
        client2.stub(:name) { "Anna" }
        @client_monitor.stub(:clients) { [client1, client2 ]}
        result = OnlineCharFinder.find("Ann", @client)
        result.target.should be_nil
        result.error.should eq "db.ambiguous_char_online"
      end
      
      it "should return failure result if nothing found" do
        client1 = double
        client1.stub(:name) { "Anne" }
        @client_monitor.stub(:clients) { [client1 ]}
        result = OnlineCharFinder.find("Bob", @client)
        result.target.should be_nil
        result.error.should eq "db.no_char_online_found"
      end
    end
  end
end