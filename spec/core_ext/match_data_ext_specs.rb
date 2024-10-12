

require "aresmush"

module AresMUSH

  describe MatchData do
    describe :names_hash do
      it "should make a hash of the names and arg values" do
        str = "a b"
        m = /(?<foo>.+) (?<bar>.+)/.match(str)
        data = { :foo => "a", :bar => "b" }
        expect(m.names_hash).to eq data
      end
    end
  end
end
