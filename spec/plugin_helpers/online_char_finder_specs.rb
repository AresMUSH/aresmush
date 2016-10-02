$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe OnlineCharFinder do
    describe :find do
      before do
        @client = double
        @client_monitor = double
        @client1 = double
        @client2 = double
        @char1 = double
        @char2 = double
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
        @char1.stub(:name_upcase) { "HARVEY" }
        @char1.stub(:alias_upcase) { nil }
        @char2.stub(:name_upcase) { "BOB" }
        @char2.stub(:alias_upcase) { nil }
        @client_monitor.stub(:logged_in) { {@client1 => @char1, @client2 => @char2 }}
        result = OnlineCharFinder.find("bo", @client)
        result.target.client.should eq @client2
        result.target.char.should eq @char2
        result.error.should be_nil
      end
      
      it "should return a matching online char by alias" do
        @char1.stub(:name_upcase) { "HARVEY" }
        @char1.stub(:alias_upcase) { "HVY" }
        @client_monitor.stub(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("hvy", @client)
        result.target.client.should eq @client1
        result.target.char.should eq @char1
        result.error.should be_nil
      end
      
      
      it "should ensure only a single result" do
        @char1.stub(:name_upcase) { "ANNE" }
        @char2.stub(:name_upcase) { "ANNA" }
        @char1.stub(:alias_upcase) { nil }
        @char2.stub(:alias_upcase) { nil }
        @client_monitor.stub(:logged_in) { {@client1 => @char1, @client2 => @char2 }}
        result = OnlineCharFinder.find("Ann", @client)
        result.target.should be_nil
        result.error.should eq "db.ambiguous_char_online"
      end
      
      it "should match someone's actual name even if a partial name also exists" do
        @char1.stub(:name_upcase) { "ANN" }
        @char2.stub(:name_upcase) { "ANNA" }
        @char1.stub(:alias_upcase) { nil }
        @char2.stub(:alias_upcase) { nil }
        @client_monitor.stub(:logged_in) { {@client1 => @char1, @client2 => @char2 }}
        result = OnlineCharFinder.find("Ann", @client)
        result.target.client.should eq @client1
        result.target.char.should eq @char1
        result.error.should be_nil
      end
      
      it "should match a handle if allowed to" do
        @char1.stub(:name_upcase) { "HARVEY" }
        @char1.stub(:alias_upcase) { "HVY" }
        @char1.stub(:handle) { "@Nemo" }
        @char1.stub(:handle_visible_to?).with(@client) { true }
        @client_monitor.stub(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("@Nemo", @client, true)
        result.target.client.should eq @client1
        result.target.char.should eq @char1
        result.error.should be_nil
      end
      
      it "should match part of a handle if allowed to" do
        @char1.stub(:name_upcase) { "HARVEY" }
        @char1.stub(:alias_upcase) { "HVY" }
        @char1.stub(:handle) { "@Nemo" }
        @char1.stub(:handle_visible_to?).with(@client) { true }
        @client_monitor.stub(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("@Nem", @client, true)
        result.target.client.should eq @client1
        result.target.char.should eq @char1
        result.error.should be_nil
      end
      
      it "should not match a handle if not allowed" do
        @char1.stub(:name_upcase) { "HARVEY" }
        @char1.stub(:alias_upcase) { "HVY" }
        @char1.stub(:handle) { "@Nemo" }
        @client_monitor.stub(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("@Nemo", @client, false)
        result.target.should be_nil
        result.error.should eq "db.no_char_online_found"
      end     
      
      it "should not match a handle if handle can't be seen" do
        @char1.stub(:name_upcase) { "HARVEY" }
        @char1.stub(:alias_upcase) { "HVY" }
        @char1.stub(:handle) { "@Nemo" }
        @char1.stub(:handle_visible_to?).with(@client) { false }
        @client_monitor.stub(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("@Nemo", @client, false)
        result.target.should be_nil
        result.error.should eq "db.no_char_online_found"
      end      
      
      it "should return failure result if nothing found" do
        @char1.stub(:name_upcase) { "ANNE" }
        @char1.stub(:alias_upcase) { nil }
        @client_monitor.stub(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("Bob", @client)
        result.target.should be_nil
        result.error.should eq "db.no_char_online_found"
      end
    end
    
    describe :with_online_chars do
      before do
        @client = double
      end
      
      it "should emit failure if a char doesn't exist" do
        result = FindResult.new(nil, "error msg")
        OnlineCharFinder.should_receive(:find).with("n1", @client, false) { result }
        @client.should_receive(:emit_failure).with("error msg")
        OnlineCharFinder.with_online_chars(["n1", "n2"], @client) do |clients|
          raise "Should not get here."
        end
      end
      
      it "should call the block with the clients if they exist" do
        client1 = double
        client2 = double
        OnlineCharFinder.should_receive(:find).with("n1", @client, false) { FindResult.new(client1, nil) }
        OnlineCharFinder.should_receive(:find).with("n2", @client, false) { FindResult.new(client2, nil) }
        OnlineCharFinder.with_online_chars(["n1", "n2"], @client) do |clients|
          clients.should eq [client1, client2]
        end
      end
    end
  end
end