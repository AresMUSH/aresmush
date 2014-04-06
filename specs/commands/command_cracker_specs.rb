$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe CommandCracker do

    describe "crack" do
      
      it "should be able to crack a root-only command" do
        cracked = CommandCracker.crack("test")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:switch].should eq nil
        cracked[:args].should eq nil
      end

      it "should be able to crack a root followed by a number" do
        cracked = CommandCracker.crack("test1")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:switch].should eq nil
        cracked[:args].should eq "1"
      end

      it "should be able to crack a root followed by a space and arg" do
        cracked = CommandCracker.crack("test abc")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:switch].should eq nil
        cracked[:args].should eq "abc"        
      end

      it "should be able to crack a root followed by a space and number" do
        cracked = CommandCracker.crack("test 2")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:switch].should eq nil
        cracked[:args].should eq "2"
      end

      it "should be able to crack a root followed by a slash and switch" do
        cracked = CommandCracker.crack("test/sw")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:switch].should eq "sw"
        cracked[:args].should eq nil        
      end

      it "should be able to crack a root followed by a slash and switch and arg" do
        cracked = CommandCracker.crack("test/sw arg")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:switch].should eq "sw"
        cracked[:args].should eq "arg"        
      end
      
      it "should be able to crack a root followed by a space and switch and number" do
        cracked = CommandCracker.crack("test/sw 2")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:switch].should eq "sw"
        cracked[:args].should eq "2"
      end

      it "should be able to strip off crazy spaces" do
        cracked = CommandCracker.crack("   test/sw    2   ")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:switch].should eq "sw"
        cracked[:args].should eq "2"
      end

      it "should not recognize a switch that's spaced out" do
        cracked = CommandCracker.crack("   test  /  sw    2   ")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:switch].should eq nil
        cracked[:args].should eq "/  sw    2"
      end
      
    
      it "should handle a + prefix" do
        cracked = CommandCracker.crack("+test/foo bar")
        cracked[:prefix].should eq "+"
        cracked[:root].should eq "test"
        cracked[:switch].should eq "foo"
        cracked[:args].should eq "bar"
      end  
      
      it "should handle a / prefix" do
        cracked = CommandCracker.crack("/test/foo bar")
        cracked[:prefix].should eq "/"
        cracked[:root].should eq "test"
        cracked[:switch].should eq "foo"
        cracked[:args].should eq "bar"
      end
      
      it "should handle an @ prefix" do
        cracked = CommandCracker.crack("@test/foo bar")
        cracked[:prefix].should eq "@"
        cracked[:root].should eq "test"
        cracked[:switch].should eq "foo"
        cracked[:args].should eq "bar"
      end
      
      it "should handle an = prefix" do
        cracked = CommandCracker.crack("=test/foo bar")
        cracked[:prefix].should eq "="
        cracked[:root].should eq "test"
        cracked[:switch].should eq "foo"
        cracked[:args].should eq "bar"
      end

      it "should handle no prefix" do
        cracked = CommandCracker.crack("test/foo bar")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:switch].should eq "foo"
        cracked[:args].should eq "bar"
      end
      
      it "should be able to crack an empty string" do
        cracked = CommandCracker.crack("")
        cracked[:prefix].should eq nil
        cracked[:root].should eq ""
        cracked[:switch].should eq nil
        cracked[:args].should eq nil
      end
            
      it "should substitute roots if the root is an alias" do
        Global.stub(:config) { { "alias" => { "a" => "b", "test" => "c" } } }
        cracked = CommandCracker.crack("test/foo bar")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "c"
        cracked[:switch].should eq "foo"
        cracked[:args].should eq "bar"
      end
    end
  
  end
end
