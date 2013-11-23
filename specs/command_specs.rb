$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Command do

    before do
      @client = double(Client)
    end

    describe :initialize do 
     
      it "should set the root" do
        cmd = Command.new(@client, "test/sw foo")
        cmd.root.should eq "test"
      end      

      it "should set the raw command" do
        cmd = Command.new(@client, "test/sw foo")
        cmd.raw.should eq "test/sw foo"
      end

      it "should use the command cracker to parse the command" do
        Cracker.should_receive(:crack).with("test 123") { { :root => "r", :switch => "s", :args => "a" }}
        cmd = Command.new(@client, "test 123")
        cmd.root.should eq "r"
        cmd.switch.should eq "s"
        cmd.args.should eq "a"
      end
      
      it "should save the results from cracker even if they're nil" do
        Cracker.should_receive(:crack).with("test 123") { { :root => nil, :switch => nil, :args => nil }}
        cmd = Command.new(@client, "test 123")
        cmd.root.should eq nil
        cmd.switch.should eq nil
        cmd.args.should eq nil
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
      # Note - more in-depth testing in :cmd_root
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

    describe :crack_args! do
      it "should expand the args string into a more meaningful hash" do
        cmd = Command.new(@client, "test/foo bar=baz+harvey")
        cmd.crack_args!(/(?<a>.+)=(?<b>.+)\+(?<c>.+)/)
        cmd.args.a.should eq "bar"
        cmd.args.b.should eq "baz"
        cmd.args.c.should eq "harvey"
      end
      
      it "should still return a hash reader it can't crack the args" do 
        cmd = Command.new(@client, "test/foo bar=baz+harvey")
        cmd.crack_args!(/(?<a>.+)\/(?<b>.+)/)
        cmd.args.a.should be_nil
        cmd.args.b.should be_nil
      end
    end

    describe :can_crack_args? do
      it "should be true if it can crack the args" do
        cmd = Command.new(@client, "test/foo bar=baz+harvey")
        cmd.can_crack_args?(/(?<a>.+)=(?<b>.+)\+(?<c>.+)/).should be_true
      end
      
      it "should be false if it can't crack the args" do
        cmd = Command.new(@client, "test/foo bar=baz+harvey")
        cmd.can_crack_args?(/(?<a>.+)\/(?<b>.+)/).should be_false
      end
    end    
  end
end
