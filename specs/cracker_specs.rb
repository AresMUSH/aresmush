$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Cracker do

    describe "crack" do
      
      it "should be able to crack a root-only command" do
        cracked = Cracker.crack("test")
        cracked[:root].should eq "test"
        cracked[:switch].should eq nil
        cracked[:args].should eq nil
      end

      it "should be able to crack a root followed by a number" do
        cracked = Cracker.crack("test1")
        cracked[:root].should eq "test"
        cracked[:switch].should eq nil
        cracked[:args].should eq "1"
      end

      it "should be able to crack a root followed by a space and arg" do
        cracked = Cracker.crack("test abc")
        cracked[:root].should eq "test"
        cracked[:switch].should eq nil
        cracked[:args].should eq "abc"        
      end

      it "should be able to crack a root followed by a space and number" do
        cracked = Cracker.crack("test 2")
        cracked[:root].should eq "test"
        cracked[:switch].should eq nil
        cracked[:args].should eq "2"
      end

      it "should be able to crack a root followed by a slash and switch" do
        cracked = Cracker.crack("test/sw")
        cracked[:root].should eq "test"
        cracked[:switch].should eq "sw"
        cracked[:args].should eq nil        
      end

      it "should be able to crack a root followed by a slash and switch and arg" do
        cracked = Cracker.crack("test/sw arg")
        cracked[:root].should eq "test"
        cracked[:switch].should eq "sw"
        cracked[:args].should eq "arg"        
      end
      
      it "should be able to crack a root followed by a space and switch and number" do
        cracked = Cracker.crack("test/sw 2")
        cracked[:root].should eq "test"
        cracked[:switch].should eq "sw"
        cracked[:args].should eq "2"
      end

      it "should be able to strip off crazy spaces" do
        cracked = Cracker.crack("   test/sw    2   ")
        cracked[:root].should eq "test"
        cracked[:switch].should eq "sw"
        cracked[:args].should eq "2"
      end

      it "should not recognize a switch that's spaced out" do
        cracked = Cracker.crack("   test  /  sw    2   ")
        cracked[:root].should eq "test"
        cracked[:switch].should eq nil
        cracked[:args].should eq "/  sw    2"
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
        cracked[:root]_is?("test").should be_true
      end

      it "should not match a different root" do
          cmd = Command.new(@client, "test/foo bar")
          cracked[:root]_is?("foo").should be_false
        end
      
      it "should ignore case in the root" do
          cmd = Command.new(@client, "TesT/foo bar")
          cracked[:root]_is?("test").should be_true
      end        
    end

    describe :crack_args! do
      it "should expand the args string into a more meaningful hash" do
        cmd = Command.new(@client, "test/foo bar=baz+harvey")
        cmd.crack_args!(/(?<a>.+)=(?<b>.+)\+(?<c>.+)/)
        cracked[:args].a.should eq "bar"
        cracked[:args].b.should eq "baz"
        cracked[:args].c.should eq "harvey"
      end
      
      it "should still return a hash reader it can't crack the args" do 
        cmd = Command.new(@client, "test/foo bar=baz+harvey")
        cmd.crack_args!(/(?<a>.+)\/(?<b>.+)/)
        cracked[:args].a.should be_nil
        cracked[:args].b.should be_nil
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
