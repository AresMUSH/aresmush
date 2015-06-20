$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe CommonCracks do
    describe "arg1_slash_arg2" do
      it "should crack a matching command" do
        args = ArgCracker.crack(CommonCracks.arg1_slash_arg2, "a/b")
        args.arg1.should eq "a"
        args.arg2.should eq "b"
      end
      
      it "should set values to nil if not matched" do
        args = ArgCracker.crack(CommonCracks.arg1_slash_arg2, "a b")
        args.arg1.should be_nil
        args.arg2.should be_nil
      end
    end
    
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
    
    describe "arg1_slash_optional_arg2" do
      it "should crack a matching command" do
        args = ArgCracker.crack(CommonCracks.arg1_slash_optional_arg2, "a/b")
        args.arg1.should eq "a"
        args.arg2.should eq "b"
      end
      
      it "should crack a matching command with missing optional arg" do
        args = ArgCracker.crack(CommonCracks.arg1_slash_optional_arg2, "a")
        args.arg1.should eq "a"
        args.arg2.should be_nil
      end
      
      it "should set values to nil if not matched" do
        args = ArgCracker.crack(CommonCracks.arg1_slash_optional_arg2, "a=b")
        args.arg1.should eq "a=b"
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
    
    describe "arg1_equals_arg2_slash_arg3" do
      it "should crack a matching command" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_arg2_slash_arg3, "a=b/c")
        args.arg1.should eq "a"
        args.arg2.should eq "b"
        args.arg3.should eq "c"
      end
      
      it "should set values to nil if not matched" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_arg2, "a b")
        args.arg1.should be_nil
        args.arg2.should be_nil
        args.arg3.should be_nil
      end
      
      it "should match an arg3 with equals or slashes" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_arg2_slash_arg3, "a=b/c = d/e")
        args.arg1.should eq "a"
        args.arg2.should eq "b"
        args.arg3.should eq "c = d/e"
      end
    end
    
    describe "arg1_equals_arg2_slash_optional_arg3" do
      it "should crack a matching command" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_arg2_slash_optional_arg3, "a=b/c")
        args.arg1.should eq "a"
        args.arg2.should eq "b"
        args.arg3.should eq "c"
      end
      
      it "should crack a command without the optional arg" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_arg2_slash_optional_arg3, "a=b")
        args.arg1.should eq "a"
        args.arg2.should eq "b"
        args.arg3.should be_nil
      end
      
      it "should set values to nil if not matched" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_arg2_slash_optional_arg3, "a b")
        args.arg1.should be_nil
        args.arg2.should be_nil
        args.arg3.should be_nil
      end
      
      it "should match an arg3 with equals or slashes" do
        args = ArgCracker.crack(CommonCracks.arg1_equals_arg2_slash_optional_arg3, "a=b/c = d/e")
        args.arg1.should eq "a"
        args.arg2.should eq "b"
        args.arg3.should eq "c = d/e"
      end
    end
    
    describe "arg1_space_arg2" do
      it "should crack a matching command" do
        args = ArgCracker.crack(CommonCracks.arg1_space_arg2, "a b")
        args.arg1.should eq "a"
        args.arg2.should eq "b"
      end
      
      it "should set values to nil if not matched" do
        args = ArgCracker.crack(CommonCracks.arg1_space_arg2, "ab")
        args.arg1.should be_nil
        args.arg2.should be_nil
      end
    end
  end
end