$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Command do

    before do
      @client = double(Client)
    end

    describe :initialize do
      it "should initialize the client" do
        cmd = Command.new(@client, "test/sw foo")
        cmd.client.should eq @client
      end
      
      it "should initialize the raw input" do
        cmd = Command.new(@client, "test/sw foo")
        cmd.raw.should eq "test/sw foo"
      end
      
      it "should crack the command" do
        CommandCracker.should_receive(:crack).with("test 123") { { :root => "r", :switch => "s", :args => "a" }}
        cmd = Command.new(@client, "test 123")        
      end
    end
    
    describe :crack! do 
     
      it "should set the root" do
        cmd = Command.new(@client, "test/sw foo")
        cmd.root.should eq "test"
      end      

      it "should set the raw command" do
        cmd = Command.new(@client, "test/sw foo")
        cmd.raw.should eq "test/sw foo"
      end

      it "should use the command cracker to parse the command" do
        CommandCracker.should_receive(:crack).with("test 123") { { :root => "r", :switch => "s", :args => "a" }}
        cmd = Command.new(@client, "test 123")
        cmd.root.should eq "r"
        cmd.switch.should eq "s"
        cmd.args.should eq "a"
      end
      
      it "should save the results from cracker even if they're nil" do
        CommandCracker.should_receive(:crack).with("test 123") { { :root => nil, :switch => nil, :args => nil }}
        cmd = Command.new(@client, "test 123")
        cmd.root.should eq nil
        cmd.switch.should eq nil
        cmd.args.should eq nil
      end
      
      it "should crack the args if the optional regex is provided" do
        regex = /.+/
        ArgCracker.should_receive(:crack).with(regex, "123") { HashReader.new({ :a => "a" }) }
        cmd = Command.new(@client, "test 123")
        cmd.crack!(regex)
        cmd.args.a.should eq "a"
      end
      
    end

    describe :logged_in? do  
      before do
        @cmd = Command.new(@client, "test/sw foo")
      end

      it "returns true if the char is set" do
        @client.stub(:char) { { "name" => "Bob"} }
        @cmd.logged_in?.should be_true
      end

      it "returns false if the char is not set" do
        @client.stub(:char) { nil }
        @cmd.logged_in?.should be_false
      end
    end

    describe :root_is? do      
      it "should match the specified root" do
        cmd = Command.new(@client, "test/foo bar")
        cmd.root_is?("test").should be_true
      end

      it "should not match a different root" do
        cmd = Command.new(@client, "test/foo bar")
        cmd.root_is?("foo").should be_false
      end
      
      it "should ignore case in the root" do
        cmd = Command.new(@client, "TesT/foo bar")
        cmd.root_is?("test").should be_true
      end            
    end
    
    describe :root_only? do
      it "should return true if there's no switch and no args" do
        cmd = Command.new(@client, "test")
        cmd.root_only?.should be_true
      end
      
      it "should return false if there's a switch" do
        cmd = Command.new(@client, "test/foo")
        cmd.root_only?.should be_false
      end

      it "should return false if there's an arg" do
        cmd = Command.new(@client, "test foo")
        cmd.root_only?.should be_false
      end
      
      it "should return false if there's both a switch and arg" do
        cmd = Command.new(@client, "test/foo bar")
        cmd.root_only?.should be_false
      end        
    end
  end
end
