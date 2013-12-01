$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  
  class ToLiquidTester
    include ToLiquidHelper
    def foo
      "FOO"
    end
    def bar
      1 + 2
    end
  end
  
  describe ToLiquidHelper do
    describe :to_liquid do
      it "should return a hash of method values" do
        tester = ToLiquidTester.new
        liquid = tester.to_liquid
        liquid["foo"].should eq "FOO"
        liquid["bar"].should eq 3
      end
      
      it "should work with a liquid template" do
        tester = ToLiquidTester.new
        template = Liquid::Template.parse("Test {{foo}} {{bar}}")
        template.render(tester.to_liquid).should eq "Test FOO 3"
      end
    end
  end
end
