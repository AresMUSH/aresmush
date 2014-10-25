$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ArgCracker do

    describe :crack do
      it "should expand the args string into a more meaningful hash" do
        args = ArgCracker.crack(/(?<a>.+)=(?<b>.+)\+(?<c>.+)/, "bar=baz+harvey")
        args.a.should eq "bar"
        args.b.should eq "baz"
        args.c.should eq "harvey"
      end
  
      it "should still return a hash reader it can't crack the args" do 
        args = ArgCracker.crack(/(?<a>.+)\/(?<b>.+)/, "bar=baz+harvey")
        args.a.should be_nil
        args.b.should be_nil
      end
    end

    describe :can_crack_args? do
      it "should be true if it can crack the args" do
        ArgCracker.can_crack_args?(/(?<a>.+)=(?<b>.+)\+(?<c>.+)/, "bar=baz+harvey").should be_true
      end
  
      it "should be false if it can't crack the args" do
        ArgCracker.can_crack_args?(/(?<a>.+)\/(?<b>.+)/, "bar=baz+harvey").should be_false
      end
    end    
  
  end
end

