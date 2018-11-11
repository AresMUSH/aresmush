$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe CommandCracker do

    describe "crack" do
      
      it "should be able to crack a root-only command" do
        cracked = CommandCracker.crack("test")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq nil
        expect(cracked[:args]).to eq nil
      end

      it "should be able to crack a root that's just a number" do
        cracked = CommandCracker.crack("1")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "1"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq nil
        expect(cracked[:args]).to eq nil
      end
      
      it "should be able to crack a root with a page" do
        cracked = CommandCracker.crack("test1")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq nil
        expect(cracked[:args]).to eq nil
      end

      it "should be able to crack a root with a page and an arg" do
        cracked = CommandCracker.crack("test2 foo")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 2
        expect(cracked[:switch]).to eq nil
        expect(cracked[:args]).to eq "foo"        
      end
      
      it "should be able to crack a root followed by a space and arg" do
        cracked = CommandCracker.crack("test abc")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq nil
        expect(cracked[:args]).to eq "abc"        
      end

      it "should be able to crack a root followed by a space and number" do
        cracked = CommandCracker.crack("test 2")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq nil
        expect(cracked[:args]).to eq "2"
      end

      it "should be able to crack a root followed by a slash and switch" do
        cracked = CommandCracker.crack("test/sw")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq "sw"
        expect(cracked[:args]).to eq nil        
      end
      
      it "should be able to crack a root with page followed by a slash and switch" do
        cracked = CommandCracker.crack("test2/sw")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 2
        expect(cracked[:switch]).to eq "sw"
        expect(cracked[:args]).to eq nil        
      end
      
      it "should be able to crack a root with page after the switch" do
        cracked = CommandCracker.crack("test/sw2")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 2
        expect(cracked[:switch]).to eq "sw"
        expect(cracked[:args]).to eq nil        
      end

      it "should be able to crack a root followed by a slash and switch and arg" do
        cracked = CommandCracker.crack("test/sw arg")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq "sw"
        expect(cracked[:args]).to eq "arg"        
      end
      
      it "should be able to crack a root followed by a space and switch and number" do
        cracked = CommandCracker.crack("test/sw 2")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq "sw"
        expect(cracked[:args]).to eq "2"
      end

      it "should be able to strip off crazy spaces" do
        cracked = CommandCracker.crack("   test/sw    2   ")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq "sw"
        expect(cracked[:args]).to eq "2"
      end

      it "should not recognize a switch that's spaced out" do
        cracked = CommandCracker.crack("   test  /  sw    2   ")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq nil
        expect(cracked[:args]).to eq "/  sw    2"
      end
      
    
      it "should handle a + prefix" do
        cracked = CommandCracker.crack("+test/foo bar")
        expect(cracked[:prefix]).to eq "+"
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq "foo"
        expect(cracked[:args]).to eq "bar"
      end  
      
      it "should handle a / prefix" do
        cracked = CommandCracker.crack("/test/foo bar")
        expect(cracked[:prefix]).to eq "/"
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq "foo"
        expect(cracked[:args]).to eq "bar"
      end
      
      it "should handle an @ prefix" do
        cracked = CommandCracker.crack("@test/foo bar")
        expect(cracked[:prefix]).to eq "@"
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq "foo"
        expect(cracked[:args]).to eq "bar"
      end
      
      it "should handle an = prefix" do
        cracked = CommandCracker.crack("=test/foo bar")
        expect(cracked[:prefix]).to eq "="
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq "foo"
        expect(cracked[:args]).to eq "bar"
      end

      it "should handle an & prefix" do
        cracked = CommandCracker.crack("&test/foo bar")
        expect(cracked[:prefix]).to eq "&"
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq "foo"
        expect(cracked[:args]).to eq "bar"
      end
      
      it "should handle no prefix" do
        cracked = CommandCracker.crack("test/foo bar")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq "foo"
        expect(cracked[:args]).to eq "bar"
      end
      
      it "should handle a weird prefix" do
        cracked = CommandCracker.crack("~test/foo bar")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq "~test"
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq "foo"
        expect(cracked[:args]).to eq "bar"
      end
      
      it "should be able to crack an empty string" do
        cracked = CommandCracker.crack("")
        expect(cracked[:prefix]).to eq nil
        expect(cracked[:root]).to eq ""
        expect(cracked[:page]).to eq 1
        expect(cracked[:switch]).to eq nil
        expect(cracked[:args]).to eq nil
      end
    end
  
    describe :strip_prefix do
      it "should remove prefixes" do
        expect(CommandCracker.strip_prefix("+xyz")).to eq "xyz"
        expect(CommandCracker.strip_prefix("@xyz")).to eq "xyz"
        expect(CommandCracker.strip_prefix("=xyz")).to eq "xyz"
        expect(CommandCracker.strip_prefix("&xyz")).to eq "xyz"
        expect(CommandCracker.strip_prefix("xyz")).to eq "xyz"
      end
    end
    
  end
end
