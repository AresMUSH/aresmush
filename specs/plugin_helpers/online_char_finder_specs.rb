$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe OnlineCharFinder do
    describe :find do
      before do
        @client = double
        @client_monitor = double
        create_stub_clients
        Global.stub(:client_monitor) { @client_monitor }
        SpecHelpers.stub_translate_for_testing
      end

      def create_stub_clients
        @client1 = double
        @client2 = double
        @char1 = double("C1")
        @char2 = double("C2")
        @client1.stub(:char) { @char1 }
        @client2.stub(:char) { @char2 }
      end
        
      it "should return the client for the me keword" do
        char = double
        result = OnlineCharFinder.find("me", @client)
        result.target.should eq @client
        result.error.should be_nil
      end

      it "should return a matching online char" do
        @char1.stub(:name_upcase) { "HARVEY" }
        @char1.stub(:alias_upcase) { nil }
        @char2.stub(:name_upcase) { "BOB" }
        @char2.stub(:alias_upcase) { nil }
        @client_monitor.stub(:logged_in_clients) { [@client1, @client2 ]}
        result = OnlineCharFinder.find("bo", @client)
        result.target.should eq @client2
        result.error.should be_nil
      end
      
      it "should return a matching online char by alias" do
        @char1.stub(:name_upcase) { "HARVEY" }
        @char1.stub(:alias_upcase) { "HVY" }
        @client_monitor.stub(:logged_in_clients) { [@client1 ]}
        result = OnlineCharFinder.find("hvy", @client)
        result.target.should eq @client1
        result.error.should be_nil
      end
      
      
      it "should ensure only a single result" do
        @char1.stub(:name_upcase) { "ANNE" }
        @char2.stub(:name_upcase) { "ANNA" }
        @char1.stub(:alias_upcase) { nil }
        @char2.stub(:alias_upcase) { nil }
        @client_monitor.stub(:logged_in_clients) { [@client1, @client2 ]}
        result = OnlineCharFinder.find("Ann", @client)
        result.target.should be_nil
        result.error.should eq "db.ambiguous_char_online"
      end
      
      it "should match someone's actual name even if a partial name also exists" do
        @char1.stub(:name_upcase) { "ANN" }
        @char2.stub(:name_upcase) { "ANNA" }
        @char1.stub(:alias_upcase) { nil }
        @char2.stub(:alias_upcase) { nil }
        @client_monitor.stub(:logged_in_clients) { [@client1, @client2 ]}
        result = OnlineCharFinder.find("Ann", @client)
        result.target.should eq @client1
        result.error.should be_nil
      end
      
      it "should return failure result if nothing found" do
        @char1.stub(:name_upcase) { "ANNE" }
        @char1.stub(:alias_upcase) { nil }
        @client_monitor.stub(:logged_in_clients) { [@client1 ]}
        result = OnlineCharFinder.find("Bob", @client)
        result.target.should be_nil
        result.error.should eq "db.no_char_online_found"
      end
    end
  end
end