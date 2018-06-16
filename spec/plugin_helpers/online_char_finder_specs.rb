$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

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
        allow(Global).to receive(:client_monitor) { @client_monitor }
        stub_translate_for_testing
      end
     
      it "should return the client for the me keword" do
        char = double
        allow(@client).to receive(:char) { char }
        result = OnlineCharFinder.find("me", @client)
        expect(result.target.client).to eq @client
        expect(result.target.char).to eq char
        expect(result.error).to be_nil
      end

      it "should return a matching online char" do
        allow(@char1).to receive(:name_upcase) { "HARVEY" }
        allow(@char1).to receive(:alias_upcase) { nil }
        allow(@char2).to receive(:name_upcase) { "BOB" }
        allow(@char2).to receive(:alias_upcase) { nil }
        allow(@client_monitor).to receive(:logged_in) { {@client1 => @char1, @client2 => @char2 }}
        result = OnlineCharFinder.find("bo", @client)
        expect(result.target.client).to eq @client2
        expect(result.target.char).to eq @char2
        expect(result.error).to be_nil
      end
      
      it "should return a matching online char by alias" do
        allow(@char1).to receive(:name_upcase) { "HARVEY" }
        allow(@char1).to receive(:alias_upcase) { "HVY" }
        allow(@client_monitor).to receive(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("hvy", @client)
        expect(result.target.client).to eq @client1
        expect(result.target.char).to eq @char1
        expect(result.error).to be_nil
      end
      
      
      it "should ensure only a single result" do
        allow(@char1).to receive(:name_upcase) { "ANNE" }
        allow(@char2).to receive(:name_upcase) { "ANNA" }
        allow(@char1).to receive(:alias_upcase) { nil }
        allow(@char2).to receive(:alias_upcase) { nil }
        allow(@client_monitor).to receive(:logged_in) { {@client1 => @char1, @client2 => @char2 }}
        result = OnlineCharFinder.find("Ann", @client)
        expect(result.target).to be_nil
        expect(result.error).to eq "db.ambiguous_char_online"
      end
      
      it "should match someone's actual name even if a partial name also exists" do
        allow(@char1).to receive(:name_upcase) { "ANN" }
        allow(@char2).to receive(:name_upcase) { "ANNA" }
        allow(@char1).to receive(:alias_upcase) { nil }
        allow(@char2).to receive(:alias_upcase) { nil }
        allow(@client_monitor).to receive(:logged_in) { {@client1 => @char1, @client2 => @char2 }}
        result = OnlineCharFinder.find("Ann", @client)
        expect(result.target.client).to eq @client1
        expect(result.target.char).to eq @char1
        expect(result.error).to be_nil
      end
      
      it "should match a handle if allowed to" do
        allow(@char1).to receive(:name_upcase) { "HARVEY" }
        allow(@char1).to receive(:alias_upcase) { "HVY" }
        allow(@char1).to receive(:handle) { "@Nemo" }
        allow(@char1).to receive(:handle_visible_to?).with(@client) { true }
        allow(@client_monitor).to receive(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("@Nemo", @client, true)
        expect(result.target.client).to eq @client1
        expect(result.target.char).to eq @char1
        expect(result.error).to be_nil
      end
      
      it "should match part of a handle if allowed to" do
        allow(@char1).to receive(:name_upcase) { "HARVEY" }
        allow(@char1).to receive(:alias_upcase) { "HVY" }
        allow(@char1).to receive(:handle) { "@Nemo" }
        allow(@char1).to receive(:handle_visible_to?).with(@client) { true }
        allow(@client_monitor).to receive(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("@Nem", @client, true)
        expect(result.target.client).to eq @client1
        expect(result.target.char).to eq @char1
        expect(result.error).to be_nil
      end
      
      it "should not match a handle if not allowed" do
        allow(@char1).to receive(:name_upcase) { "HARVEY" }
        allow(@char1).to receive(:alias_upcase) { "HVY" }
        allow(@char1).to receive(:handle) { "@Nemo" }
        allow(@client_monitor).to receive(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("@Nemo", @client, false)
        expect(result.target).to be_nil
        expect(result.error).to eq "db.no_char_online_found"
      end     
      
      it "should not match a handle if handle can't be seen" do
        allow(@char1).to receive(:name_upcase) { "HARVEY" }
        allow(@char1).to receive(:alias_upcase) { "HVY" }
        allow(@char1).to receive(:handle) { "@Nemo" }
        allow(@char1).to receive(:handle_visible_to?).with(@client) { false }
        allow(@client_monitor).to receive(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("@Nemo", @client, false)
        expect(result.target).to be_nil
        expect(result.error).to eq "db.no_char_online_found"
      end      
      
      it "should return failure result if nothing found" do
        allow(@char1).to receive(:name_upcase) { "ANNE" }
        allow(@char1).to receive(:alias_upcase) { nil }
        allow(@client_monitor).to receive(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("Bob", @client)
        expect(result.target).to be_nil
        expect(result.error).to eq "db.no_char_online_found"
      end
    end
    
    describe :with_online_chars do
      before do
        @client = double
      end
      
      it "should emit failure if a char doesn't exist" do
        result = FindResult.new(nil, "error msg")
        expect(OnlineCharFinder).to receive(:find).with("n1", @client, false) { result }
        expect(@client).to receive(:emit_failure).with("error msg")
        OnlineCharFinder.with_online_chars(["n1", "n2"], @client) do |clients|
          raise "Should not get here."
        end
      end
      
      it "should call the block with the clients if they exist" do
        client1 = double
        client2 = double
        expect(OnlineCharFinder).to receive(:find).with("n1", @client, false) { FindResult.new(client1, nil) }
        expect(OnlineCharFinder).to receive(:find).with("n2", @client, false) { FindResult.new(client2, nil) }
        OnlineCharFinder.with_online_chars(["n1", "n2"], @client) do |clients|
          expect(clients).to eq [client1, client2]
        end
      end
    end
  end
end
