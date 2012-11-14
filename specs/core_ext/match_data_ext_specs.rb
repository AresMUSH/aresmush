$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe MatchData do
    describe :names_hash do
      it "should make a hash of the names and arg values" do
        str = "a b"
        m = /(?<foo>.+) (?<bar>.+)/.match(str)
        data = { "foo" => "a", "bar" => "b" }
        m.names_hash.should eq data
      end
    end
  end
end