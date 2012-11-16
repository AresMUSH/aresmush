$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  
  describe Command do
    
    before do
      @client = double(Client)
      @player = { "name" => "Bob"}
      @client.stub(:player) { @player }
    end
    
    describe :initialize do 
      before do
        @cmd = Command.new(@client, "test/sw foo")
      end
      
      it "sets the root" do
        @cmd.root.should eq "test"
      end
      
      it "sets the client" do
        @cmd.client.should eq @client
      end
      
      it "sets the enactor" do
        @cmd.enactor.should eq @player
      end
      
      it "sets the raw command" do
        @cmd.raw.should eq "test/sw foo"
      end
    end
    
    describe :initialize do      
      it "cracks a command by itself" do
        cmd = Command.new(@client, "test")
        cmd.root.should eq "test"
        cmd.switch.should eq nil
        cmd.args.should eq nil
      end

      it "cracks a root followed by a number" do
        cmd = Command.new(@client, "test1")
        cmd.root.should eq "test"
        cmd.switch.should eq nil
        cmd.args.should eq "1"
      end

      it "cracks a root followed by a space and arg" do
        cmd = Command.new(@client, "test abc")
        cmd.root.should eq "test"
        cmd.switch.should eq nil
        cmd.args.should eq "abc"        
      end

      it "cracks a root followed by a space and number" do
        cmd = Command.new(@client, "test 2")
        cmd.root.should eq "test"
        cmd.switch.should eq nil
        cmd.args.should eq "2"
      end
      
      it "cracks a root followed by a slash and switch" do
        cmd = Command.new(@client, "test/sw")
        cmd.root.should eq "test"
        cmd.switch.should eq "sw"
        cmd.args.should eq nil        
      end

      it "cracks a root followed by a slash and switch and arg" do
        cmd = Command.new(@client, "test/sw arg")
        cmd.root.should eq "test"
        cmd.switch.should eq "sw"
        cmd.args.should eq "arg"        
      end

      it "cracks a root followed by a space and switch and number" do
        cmd = Command.new(@client, "test/sw 2")
        cmd.root.should eq "test"
        cmd.switch.should eq "sw"
        cmd.args.should eq "2"
      end

      it "strips off crazy spaces" do
        cmd = Command.new(@client, "   test/sw    2   ")
        cmd.root.should eq "test"
        cmd.switch.should eq "sw"
        cmd.args.should eq "2"
      end

      it "doesn't recognize a switch that's spaced out" do
        cmd = Command.new(@client, "   test  /  sw    2   ")
        cmd.root.should eq "test"
        cmd.switch.should eq nil
        cmd.args.should eq "/  sw    2"
      end
    end

    describe :logged_in? do  
      before do
        @cmd = Command.new(@client, "test/sw foo")
      end
      
      it "returns true if the player is set" do
        @cmd.logged_in?.should be_true
      end
      
      it "returns false if the player is not set" do
        @client.stub(:player) { nil }
        cmd = Command.new(@client, "test")
        cmd.logged_in?.should be_false
      end
    end
    
    describe :root_is? do      
      # Note - more in-depth testing in :cmd_root
      it "matches the specified root" do
        cmd = Command.new(@client, "test/foo bar")
        cmd.root_is?("test").should be_true
      end

      it "doesn't match a different root" do
        cmd = Command.new(@client, "test/foo bar")
        cmd.root_is?("foo").should be_false
      end
    end
  end
end
