

require "aresmush"

module AresMUSH

  describe SingleResultSelector do
    describe :select do
      before do
        stub_translate_for_testing
      end

      it "should return a failure if given something that doesn't support array indexing" do
        result = SingleResultSelector.select("123") 
        expect(result.target).to be_nil
        expect(result.error).to eq("db.object_not_found")
      end

      it "should return false and emit failure if given something that doesn't support empty/count" do
        result = SingleResultSelector.select(123)
        expect(result.target).to be_nil
        expect(result.error).to eq("db.object_not_found")
      end

      it "should return false and emit failure for an ambiguous result" do
        result = SingleResultSelector.select([1, 2]) 
        expect(result.target).to be_nil
        expect(result.error).to eq("db.object_ambiguous")
      end

      it "should return false and emit failure for an empty result" do
        result = SingleResultSelector.select([])
        expect(result.target).to be_nil
        expect(result.error).to eq("db.object_not_found")
      end

      it "should return false and emit failure for a nil result" do
        result = SingleResultSelector.select(nil)
        expect(result.target).to be_nil
        expect(result.error).to eq("db.object_not_found")
      end

      it "should return a singular result" do
        result = SingleResultSelector.select([2])
        expect(result.target).to eq 2
        expect(result.error).to be_nil
      end
    end
  end
end
