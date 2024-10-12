

require "aresmush"

module AresMUSH

  describe Command do

    describe :initialize do      
      it "should initialize the raw input" do
        cmd = Command.new("test/sw foo")
        expect(cmd.raw).to eq "test/sw foo"
      end
      
      it "should crack the command" do
        expect(CommandCracker).to receive(:crack).with("test 123") { { :root => "r", :switch => "s", :args => "a" }}
        cmd = Command.new("test 123")        
      end
    end
    
    describe :parse_args do 
     
      it "should set the root" do
        cmd = Command.new("test/sw foo")
        expect(cmd.root).to eq "test"
      end      

      it "should set the raw command" do
        cmd = Command.new("test/sw foo")
        expect(cmd.raw).to eq "test/sw foo"
      end

      it "should use the command ArgParser to parse the command" do
        expect(CommandCracker).to receive(:crack).with("test 123") { { :root => "r", :switch => "s", :args => "a" }}
        cmd = Command.new("test 123")
        expect(cmd.root).to eq "r"
        expect(cmd.switch).to eq "s"
        expect(cmd.args).to eq "a"
      end
      
      it "should save the results from ArgParser even if they're nil" do
        expect(CommandCracker).to receive(:crack).with("test 123") { { :root => nil, :switch => nil, :args => nil }}
        cmd = Command.new("test 123")
        expect(cmd.root).to eq nil
        expect(cmd.switch).to eq nil
        expect(cmd.args).to eq nil
      end
    end

    describe :parse_args do
      it "should parse the args" do
        regex = /.+/
        expect(ArgParser).to receive(:parse).with(regex, "123") { HashReader.new({ :a => "a" }) }
        cmd = Command.new("test 123")
        args = cmd.parse_args(regex)
        expect(args.a).to eq "a"
      end
    end
    
    describe :root_is? do      
      it "should match the specified root" do
        cmd = Command.new("test/foo bar")
        expect(cmd.root_is?("test")).to be true
      end

      it "should not match a different root" do
        cmd = Command.new("test/foo bar")
        expect(cmd.root_is?("foo")).to be false
      end
      
      it "should ignore case in the root" do
        cmd = Command.new("TesT/foo bar")
        expect(cmd.root_is?("test")).to be true
      end            
    end
    
    describe :switch_is? do      
      it "should match the specified switch" do
        cmd = Command.new("test/foo bar")
        expect(cmd.switch_is?("foo")).to be true
      end

      it "should not match a different switch" do
        cmd = Command.new("test/foo bar")
        expect(cmd.switch_is?("bar")).to be false
      end
      
      it "should ignore case in the switch" do
        cmd = Command.new("test/fOO bar")
        expect(cmd.switch_is?("foo")).to be true
      end      
      
      it "should return false for a nil switch" do
        cmd = Command.new("test bar")
        expect(cmd.switch_is?("foo")).to be false
      end

      it "should true if asking about nil" do
        cmd = Command.new("test bar")
        expect(cmd.switch_is?(nil)).to be true
      end
    end
    
    describe :root_only? do
      it "should return true if there's no switch and no args" do
        cmd = Command.new("test")
        expect(cmd.root_only?).to be true
      end
      
      it "should return false if there's a switch" do
        cmd = Command.new("test/foo")
        expect(cmd.root_only?).to be false
      end

      it "should return false if there's an arg" do
        cmd = Command.new("test foo")
        expect(cmd.root_only?).to be false
      end
      
      it "should return false if there's both a switch and arg" do
        cmd = Command.new("test/foo bar")
        expect(cmd.root_only?).to be false
      end        
    end
  end
end
