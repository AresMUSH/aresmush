

require "aresmush"

module AresMUSH
  describe AnyTargetFinder do
    describe :find do
      before do
        @client = double
        allow(Exit).to receive(:find_any_by_name) { [] }
        allow(Room).to receive(:find_any_by_name) { [] }
        allow(Character).to receive(:find_any_by_name) { [] }
        allow(VisibleTargetFinder).to receive(:find) { FindResult.new(nil, "Error") }
      end

      it "should give preference to visible targets" do
        result = FindResult.new(double, nil)
        expect(VisibleTargetFinder).to receive(:find).with("A", @client) { result }
        expect(AnyTargetFinder.find("A", @client)).to eq result
      end
      
      it "should ensure only a single result" do
        room = double
        allow(room).to receive(:id) { 1 }
        allow(@client).to receive(:room) { room }
        char1 = double
        char2 = double
        exit = double
        room = double
        expect(Character).to receive(:find_any_by_name).with("A") { [char1, char2] }
        expect(Exit).to receive(:find_any_by_name).with("A") { [exit] }
        expect(Room).to receive(:find_any_by_name).with("A") { [room] }
        result = FindResult.new(nil, "an error")
        expect(SingleResultSelector).to receive(:select).with([char1, char2, exit, room]) { result }
        expect(AnyTargetFinder.find("A", @client)).to eq result
      end

      it "should remove nil results before selecting single target" do
        room = double
        allow(room).to receive(:id) { 1 }
        allow(@client).to receive(:room) { room }
        char = double
        allow(Character).to receive(:find_any_by_name) { [char] }
        allow(Exit).to receive(:find_any_by_name) { [nil] }
        allow(Room).to receive(:find_any_by_name) { [] }
        result = FindResult.new(char, nil)
        expect(SingleResultSelector).to receive(:select).with([char]) { result }
        expect(AnyTargetFinder.find("A", @client)).to eq result      
      end
    end
  end
end
