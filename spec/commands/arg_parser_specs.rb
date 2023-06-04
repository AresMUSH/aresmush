

require "aresmush"

module AresMUSH

  describe ArgParser do

    describe :crack do
      it "should expand the args string into a more meaningful hash" do
        args = ArgParser.parse(/(?<a>.+)=(?<b>.+)\+(?<c>.+)/, "bar=baz+harvey")
        expect(args.a).to eq "bar"
        expect(args.b).to eq "baz"
        expect(args.c).to eq "harvey"
      end
  
      it "should still return a hash reader it can't crack the args" do 
        args = ArgParser.parse(/(?<a>.+)\/(?<b>.+)/, "bar=baz+harvey")
        expect(args.a).to be_nil
        expect(args.b).to be_nil
      end
    end
  end
end

