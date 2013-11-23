$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe SingleResultSelector do
    describe :select do
      before do
        @client = double
        AresMUSH::Locale.stub(:translate).with("db.object_ambiguous") { "object_ambiguous" }
        AresMUSH::Locale.stub(:translate).with("db.object_not_found") { "object_not_found" }
      end

      it "should return false and emit failure if given something that doesn't support array indexing" do
        @client.should_receive(:emit_failure).with("object_not_found")
        result = SingleResultSelector.select("123", @client) 
        result.should be_nil
      end

      it "should return false and emit failure if given something that doesn't support empty/count" do
        @client.should_receive(:emit_failure).with("object_not_found")
        result = SingleResultSelector.select(123, @client)
        result.should be_nil
      end

      it "should return false and emit failure for an ambiguous result" do
        @client.should_receive(:emit_failure).with("object_ambiguous")
        result = SingleResultSelector.select([1, 2], @client) 
        result.should be_nil
      end

      it "should return false and emit failure for an empty result" do
        @client.should_receive(:emit_failure).with("object_not_found")
        result = SingleResultSelector.select([], @client)
        result.should be_nil
      end

      it "should return false and emit failure for a nil result" do
        @client.should_receive(:emit_failure).with("object_not_found")
        result = SingleResultSelector.select(nil, @client)
        result.should be_nil
      end

      it "should return a singular result" do
        result = SingleResultSelector.select([2], @client)
        result.should eq 2
      end
    end
  end
end