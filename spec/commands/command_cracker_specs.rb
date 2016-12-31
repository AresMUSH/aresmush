$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe CommandArgParser do

    describe "crack" do
      
      it "should be able to crack a root-only command" do
        cracked = CommandArgParser.crack("test")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq nil
        cracked[:args].should eq nil
      end

      it "should be able to crack a root that's just a number" do
        cracked = CommandArgParser.crack("1")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "1"
        cracked[:page].should eq 1
        cracked[:switch].should eq nil
        cracked[:args].should eq nil
      end
      
      it "should be able to crack a root with a page" do
        cracked = CommandArgParser.crack("test1")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq nil
        cracked[:args].should eq nil
      end

      it "should be able to crack a root with a page and an arg" do
        cracked = CommandArgParser.crack("test2 foo")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:page].should eq 2
        cracked[:switch].should eq nil
        cracked[:args].should eq "foo"        
      end
      
      it "should be able to crack a root followed by a space and arg" do
        cracked = CommandArgParser.crack("test abc")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq nil
        cracked[:args].should eq "abc"        
      end

      it "should be able to crack a root followed by a space and number" do
        cracked = CommandArgParser.crack("test 2")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq nil
        cracked[:args].should eq "2"
      end

      it "should be able to crack a root followed by a slash and switch" do
        cracked = CommandArgParser.crack("test/sw")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq "sw"
        cracked[:args].should eq nil        
      end
      
      it "should be able to crack a root with page followed by a slash and switch" do
        cracked = CommandArgParser.crack("test2/sw")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:page].should eq 2
        cracked[:switch].should eq "sw"
        cracked[:args].should eq nil        
      end

      it "should be able to crack a root followed by a slash and switch and arg" do
        cracked = CommandArgParser.crack("test/sw arg")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq "sw"
        cracked[:args].should eq "arg"        
      end
      
      it "should be able to crack a root followed by a space and switch and number" do
        cracked = CommandArgParser.crack("test/sw 2")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq "sw"
        cracked[:args].should eq "2"
      end

      it "should be able to strip off crazy spaces" do
        cracked = CommandArgParser.crack("   test/sw    2   ")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq "sw"
        cracked[:args].should eq "2"
      end

      it "should not recognize a switch that's spaced out" do
        cracked = CommandArgParser.crack("   test  /  sw    2   ")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq nil
        cracked[:args].should eq "/  sw    2"
      end
      
    
      it "should handle a + prefix" do
        cracked = CommandArgParser.crack("+test/foo bar")
        cracked[:prefix].should eq "+"
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq "foo"
        cracked[:args].should eq "bar"
      end  
      
      it "should handle a / prefix" do
        cracked = CommandArgParser.crack("/test/foo bar")
        cracked[:prefix].should eq "/"
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq "foo"
        cracked[:args].should eq "bar"
      end
      
      it "should handle an @ prefix" do
        cracked = CommandArgParser.crack("@test/foo bar")
        cracked[:prefix].should eq "@"
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq "foo"
        cracked[:args].should eq "bar"
      end
      
      it "should handle an = prefix" do
        cracked = CommandArgParser.crack("=test/foo bar")
        cracked[:prefix].should eq "="
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq "foo"
        cracked[:args].should eq "bar"
      end

      it "should handle an & prefix" do
        cracked = CommandArgParser.crack("&test/foo bar")
        cracked[:prefix].should eq "&"
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq "foo"
        cracked[:args].should eq "bar"
      end
      
      it "should handle no prefix" do
        cracked = CommandArgParser.crack("test/foo bar")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "test"
        cracked[:page].should eq 1
        cracked[:switch].should eq "foo"
        cracked[:args].should eq "bar"
      end
      
      it "should handle a weird prefix" do
        cracked = CommandArgParser.crack("~test/foo bar")
        cracked[:prefix].should eq nil
        cracked[:root].should eq "~test"
        cracked[:page].should eq 1
        cracked[:switch].should eq "foo"
        cracked[:args].should eq "bar"
      end
      
      it "should be able to crack an empty string" do
        cracked = CommandArgParser.crack("")
        cracked[:prefix].should eq nil
        cracked[:root].should eq ""
        cracked[:page].should eq 1
        cracked[:switch].should eq nil
        cracked[:args].should eq nil
      end
    end
  
    describe :strip_prefix do
      it "should remove prefixes" do
        CommandArgParser.strip_prefix("+xyz").should eq "xyz"
        CommandArgParser.strip_prefix("@xyz").should eq "xyz"
        CommandArgParser.strip_prefix("=xyz").should eq "xyz"
        CommandArgParser.strip_prefix("&xyz").should eq "xyz"
        CommandArgParser.strip_prefix("xyz").should eq "xyz"
      end
    end
    
  end
end
