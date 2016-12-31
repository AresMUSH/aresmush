$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ArgParser do

    describe :crack do
      it "should expand the args string into a more meaningful hash" do
        args = ArgParser.crack(/(?<a>.+)=(?<b>.+)\+(?<c>.+)/, "bar=baz+harvey")
        args.a.should eq "bar"
        args.b.should eq "baz"
        args.c.should eq "harvey"
      end
  
      it "should still return a hash reader it can't crack the args" do 
        args = ArgParser.crack(/(?<a>.+)\/(?<b>.+)/, "bar=baz+harvey")
        args.a.should be_nil
        args.b.should be_nil
      end
    end
  end
end

