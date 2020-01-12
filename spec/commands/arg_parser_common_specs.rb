$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe ArgParser do
    describe "arg1_slash_arg2" do
      it "should crack a matching command" do
        args = ArgParser.parse(ArgParser.arg1_slash_arg2, "a/b")
        expect(args.arg1).to eq "a"
        expect(args.arg2).to eq "b"
      end
      
      it "should set values to nil if not matched" do
        args = ArgParser.parse(ArgParser.arg1_slash_arg2, "a b")
        expect(args.arg1).to be_nil
        expect(args.arg2).to be_nil
      end
    end
    
    describe "arg1_equals_arg2" do
      it "should crack a matching command" do
        args = ArgParser.parse(ArgParser.arg1_equals_arg2, "a=b")
        expect(args.arg1).to eq "a"
        expect(args.arg2).to eq "b"
      end
      
      it "should set values to nil if not matched" do
        args = ArgParser.parse(ArgParser.arg1_equals_arg2, "a b")
        expect(args.arg1).to be_nil
        expect(args.arg2).to be_nil
      end
    end
    
    describe "arg1_slash_optional_arg2" do
      it "should crack a matching command" do
        args = ArgParser.parse(ArgParser.arg1_slash_optional_arg2, "a/b")
        expect(args.arg1).to eq "a"
        expect(args.arg2).to eq "b"
      end
      
      it "should crack a matching command with missing optional arg" do
        args = ArgParser.parse(ArgParser.arg1_slash_optional_arg2, "a")
        expect(args.arg1).to eq "a"
        expect(args.arg2).to be_nil
      end
      
      it "should set values to nil if not matched" do
        args = ArgParser.parse(ArgParser.arg1_slash_optional_arg2, "a=b")
        expect(args.arg1).to eq "a=b"
        expect(args.arg2).to be_nil
      end
    end
    
    describe "arg1_equals_optional_arg2" do
      it "should crack a matching command" do
        args = ArgParser.parse(ArgParser.arg1_equals_optional_arg2, "a=b")
        expect(args.arg1).to eq "a"
        expect(args.arg2).to eq "b"
      end
      
      it "should accept only the first arg" do
        args = ArgParser.parse(ArgParser.arg1_equals_optional_arg2, "a b")
        expect(args.arg1).to eq "a b"
        expect(args.arg2).to be_nil
      end
      
      it "should set values to nil if empty" do
        args = ArgParser.parse(ArgParser.arg1_equals_optional_arg2, "")
        expect(args.arg1).to be_nil
        expect(args.arg2).to be_nil
      end
    end
    
    describe "arg1_equals_arg2_slash_arg3" do
      it "should crack a matching command" do
        args = ArgParser.parse(ArgParser.arg1_equals_arg2_slash_arg3, "a=b/c")
        expect(args.arg1).to eq "a"
        expect(args.arg2).to eq "b"
        expect(args.arg3).to eq "c"
      end
      
      it "should set values to nil if not matched" do
        args = ArgParser.parse(ArgParser.arg1_equals_arg2, "a b")
        expect(args.arg1).to be_nil
        expect(args.arg2).to be_nil
        expect(args.arg3).to be_nil
      end
      
      it "should match an arg3 with equals or slashes" do
        args = ArgParser.parse(ArgParser.arg1_equals_arg2_slash_arg3, "a=b/c = d/e")
        expect(args.arg1).to eq "a"
        expect(args.arg2).to eq "b"
        expect(args.arg3).to eq "c = d/e"
      end
    end
    
    describe "arg1_equals_arg2_slash_optional_arg3" do
      it "should crack a matching command" do
        args = ArgParser.parse(ArgParser.arg1_equals_arg2_slash_optional_arg3, "a=b/c")
        expect(args.arg1).to eq "a"
        expect(args.arg2).to eq "b"
        expect(args.arg3).to eq "c"
      end
      
      it "should crack a command without the optional arg" do
        args = ArgParser.parse(ArgParser.arg1_equals_arg2_slash_optional_arg3, "a=b")
        expect(args.arg1).to eq "a"
        expect(args.arg2).to eq "b"
        expect(args.arg3).to be_nil
      end
      
      it "should set values to nil if not matched" do
        args = ArgParser.parse(ArgParser.arg1_equals_arg2_slash_optional_arg3, "a b")
        expect(args.arg1).to be_nil
        expect(args.arg2).to be_nil
        expect(args.arg3).to be_nil
      end
      
      it "should match an arg3 with equals or slashes" do
        args = ArgParser.parse(ArgParser.arg1_equals_arg2_slash_optional_arg3, "a=b/c = d/e")
        expect(args.arg1).to eq "a"
        expect(args.arg2).to eq "b"
        expect(args.arg3).to eq "c = d/e"
      end
    end
    
    describe "flexible_args" do
      it "should crack a equals b slash c" do
        args = ArgParser.parse(ArgParser.flexible_args, "a=b/c")
        expect(args.arg1).to eq "a"
        expect(args.arg2).to eq "b"
        expect(args.arg3).to eq "c"
      end
      
      it "should crack a equals b" do
        args = ArgParser.parse(ArgParser.flexible_args, "a=b")
        expect(args.arg1).to eq "a"
        expect(args.arg2).to eq "b"
        expect(args.arg3).to be_nil
      end
      
      it "should crack a slash b" do
        args = ArgParser.parse(ArgParser.flexible_args, "a/b")
        expect(args.arg1).to eq "a"
        expect(args.arg2).to be_nil
        expect(args.arg3).to eq "b"
      end
      
      it "should crack a by itself" do
        args = ArgParser.parse(ArgParser.flexible_args, "a!! b...c")
        expect(args.arg1).to eq "a!! b...c"
        expect(args.arg2).to be_nil
        expect(args.arg3).to be_nil
      end
      
      it "should crack no args" do
        args = ArgParser.parse(ArgParser.flexible_args, "")
        expect(args.arg1).to be_nil
        expect(args.arg2).to be_nil
        expect(args.arg3).to be_nil
      end
      
      it "should match an arg3 with equals or slashes" do
        args = ArgParser.parse(ArgParser.flexible_args, "a b c=d/e = f/g")
        expect(args.arg1).to eq "a b c"
        expect(args.arg2).to eq "d"
        expect(args.arg3).to eq "e = f/g"
      end
    end
  end
end
