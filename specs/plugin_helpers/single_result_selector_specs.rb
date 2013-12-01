$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe SingleResultSelector do
    describe :select do
      before do
        SpecHelpers.stub_translate_for_testing
      end

      it "should return a failure if given something that doesn't support array indexing" do
        result = SingleResultSelector.select("123") 
        result.target.should be_nil
        result.error.should eq("db.object_not_found")
      end

      it "should return false and emit failure if given something that doesn't support empty/count" do
        result = SingleResultSelector.select(123)
        result.target.should be_nil
        result.error.should eq("db.object_not_found")
      end

      it "should return false and emit failure for an ambiguous result" do
        result = SingleResultSelector.select([1, 2]) 
        result.target.should be_nil
        result.error.should eq("db.object_ambiguous")
      end

      it "should return false and emit failure for an empty result" do
        result = SingleResultSelector.select([])
        result.target.should be_nil
        result.error.should eq("db.object_not_found")
      end

      it "should return false and emit failure for a nil result" do
        result = SingleResultSelector.select(nil)
        result.target.should be_nil
        result.error.should eq("db.object_not_found")
      end

      it "should return a singular result" do
        result = SingleResultSelector.select([2])
        result.target.should eq 2
        result.error.should be_nil
      end
    end
  end
end