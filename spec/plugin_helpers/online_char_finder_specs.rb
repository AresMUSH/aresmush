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
     
      it "should return a matching online char" do
        allow(@char1).to receive(:name_upcase) { "HARVEY" }
        allow(@char1).to receive(:alias_upcase) { nil }
        allow(@char2).to receive(:name_upcase) { "BOB" }
        allow(@char2).to receive(:alias_upcase) { nil }
        allow(@client_monitor).to receive(:logged_in) { {@client1 => @char1, @client2 => @char2 }}
        result = OnlineCharFinder.find("bo")
        expect(result.target.client).to eq @client2
        expect(result.target.char).to eq @char2
        expect(result.error).to be_nil
      end
      
      it "should return a matching online char by alias" do
        allow(@char1).to receive(:name_upcase) { "HARVEY" }
        allow(@char1).to receive(:alias_upcase) { "HVY" }
        allow(@client_monitor).to receive(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("hvy")
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
        result = OnlineCharFinder.find("Ann")
        expect(result.target).to be_nil
        expect(result.error).to eq "db.ambiguous_char_online"
      end
      
      it "should match someone's actual name even if a partial name also exists" do
        allow(@char1).to receive(:name_upcase) { "ANN" }
        allow(@char2).to receive(:name_upcase) { "ANNA" }
        allow(@char1).to receive(:alias_upcase) { nil }
        allow(@char2).to receive(:alias_upcase) { nil }
        allow(@client_monitor).to receive(:logged_in) { {@client1 => @char1, @client2 => @char2 }}
        result = OnlineCharFinder.find("Ann")
        expect(result.target.client).to eq @client1
        expect(result.target.char).to eq @char1
        expect(result.error).to be_nil
      end
      
      it "should return failure result if nothing found" do
        allow(@char1).to receive(:name_upcase) { "ANNE" }
        allow(@char1).to receive(:alias_upcase) { nil }
        allow(@client_monitor).to receive(:logged_in) { {@client1 => @char1 }}
        result = OnlineCharFinder.find("Bob")
        expect(result.target).to be_nil
        expect(result.error).to eq "db.no_char_online_found"
      end
    end
    
    describe :with_online_chars do
      before do
        @client = double
      end
      
      it "should emit failure if a char doesn't exist" do
        result1 = FindResult.new(nil, "error msg")
        expect(OnlineCharFinder).to receive(:find).with("n1") { result1 }
        expect(@client).to receive(:emit_failure).with("error msg")
        OnlineCharFinder.with_online_chars(["n1", "n2"], @client) do |results|
          raise "Should not get here."
        end
      end
      
      it "should call the block with the clients if they exist" do
        result1 = double
        result2 = double
        expect(OnlineCharFinder).to receive(:find).with("n1") { FindResult.new(result1, nil) }
        expect(OnlineCharFinder).to receive(:find).with("n2") { FindResult.new(result2, nil) }
        OnlineCharFinder.with_online_chars(["n1", "n2"], @client) do |results|
          expect(results).to eq [result1, result2]
        end
      end
    end
    
    describe :with_an_online_char do
      before do
        @client = double
      end
      
      it "should emit failure if a char doesn't exist" do
        result1 = FindResult.new(nil, "error msg")
        expect(OnlineCharFinder).to receive(:find).with("n1") { result1 }
        expect(@client).to receive(:emit_failure).with("error msg")
        OnlineCharFinder.with_an_online_char("n1", @client) do |result|
          raise "Should not get here."
        end
      end
      
      it "should call the block with the result if they exist" do
        result1 = double
        expect(OnlineCharFinder).to receive(:find).with("n1") { FindResult.new(result1, nil) }
        OnlineCharFinder.with_an_online_char("n1", @client) do |result|
          expect(result).to eq result1
        end
      end
    end
  end
end
