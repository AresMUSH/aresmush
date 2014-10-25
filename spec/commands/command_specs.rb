$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Command do

    describe :initialize do      
      it "should initialize the raw input" do
        cmd = Command.new("test/sw foo")
        cmd.raw.should eq "test/sw foo"
      end
      
      it "should crack the command" do
        CommandCracker.should_receive(:crack).with("test 123") { { :root => "r", :switch => "s", :args => "a" }}
        cmd = Command.new("test 123")        
      end
    end
    
    describe :crack! do 
     
      it "should set the root" do
        cmd = Command.new("test/sw foo")
        cmd.root.should eq "test"
      end      

      it "should set the raw command" do
        cmd = Command.new("test/sw foo")
        cmd.raw.should eq "test/sw foo"
      end

      it "should use the command cracker to parse the command" do
        CommandCracker.should_receive(:crack).with("test 123") { { :root => "r", :switch => "s", :args => "a" }}
        cmd = Command.new("test 123")
        cmd.root.should eq "r"
        cmd.switch.should eq "s"
        cmd.args.should eq "a"
      end
      
      it "should save the results from cracker even if they're nil" do
        CommandCracker.should_receive(:crack).with("test 123") { { :root => nil, :switch => nil, :args => nil }}
        cmd = Command.new("test 123")
        cmd.root.should eq nil
        cmd.switch.should eq nil
        cmd.args.should eq nil
      end
    end

    describe :crack_args! do
      it "should crack the args" do
        regex = /.+/
        ArgCracker.should_receive(:crack).with(regex, "123") { HashReader.new({ :a => "a" }) }
        cmd = Command.new("test 123")
        cmd.crack_args!(regex)
        cmd.args.a.should eq "a"
      end
    end
    
    describe :root_is? do      
      it "should match the specified root" do
        cmd = Command.new("test/foo bar")
        cmd.root_is?("test").should be_true
      end

      it "should not match a different root" do
        cmd = Command.new("test/foo bar")
        cmd.root_is?("foo").should be_false
      end
      
      it "should ignore case in the root" do
        cmd = Command.new("TesT/foo bar")
        cmd.root_is?("test").should be_true
      end            
    end
    
    describe :switch_is? do      
      it "should match the specified switch" do
        cmd = Command.new("test/foo bar")
        cmd.switch_is?("foo").should be_true
      end

      it "should not match a different switch" do
        cmd = Command.new("test/foo bar")
        cmd.switch_is?("bar").should be_false
      end
      
      it "should ignore case in the switch" do
        cmd = Command.new("test/fOO bar")
        cmd.switch_is?("foo").should be_true
      end      
      
      it "should return false for a nil root" do
        cmd = Command.new("test bar")
        cmd.switch_is?("foo").should be_false
      end
    end
    
    describe :root_only? do
      it "should return true if there's no switch and no args" do
        cmd = Command.new("test")
        cmd.root_only?.should be_true
      end
      
      it "should return false if there's a switch" do
        cmd = Command.new("test/foo")
        cmd.root_only?.should be_false
      end

      it "should return false if there's an arg" do
        cmd = Command.new("test foo")
        cmd.root_only?.should be_false
      end
      
      it "should return false if there's both a switch and arg" do
        cmd = Command.new("test/foo bar")
        cmd.root_only?.should be_false
      end        
    end
  end
end
