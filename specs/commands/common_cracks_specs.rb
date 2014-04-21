$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe CommonCracks do
    describe "arg1_equals_arg2" do
      it "should crack a matching command" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_arg2, "a=b")
        args.arg1.should eq "a"
        args.arg2.should eq "b"
      end
      
      it "should set values to nil if not matched" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_arg2, "a b")
        args.arg1.should be_nil
        args.arg2.should be_nil
      end
    end
    
    describe "arg1_equals_optional_arg2" do
      it "should crack a matching command" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_optional_arg2, "a=b")
        args.arg1.should eq "a"
        args.arg2.should eq "b"
      end
      
      it "should accept only the first arg" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_optional_arg2, "a b")
        args.arg1.should eq "a b"
        args.arg2.should be_nil
      end
      
      it "should set values to nil if empty" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_optional_arg2, "")
        args.arg1.should be_nil
        args.arg2.should be_nil
      end
    end
    
    describe "arg1_space_arg2" do
      it "should crack a matching command" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_arg2, "a b")
        args.arg1.should eq "a"
        args.arg2.should eq "b"
      end
      
      it "should set values to nil if not matched" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_arg2, "ab")
        args.arg1.should be_nil
        args.arg2.should be_nil
      end
    end
  end
end