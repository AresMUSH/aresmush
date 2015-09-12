$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  # Too much of a pain to test in isolation, so these are more of integration tests
  # with real Liquid templates.
  describe TemplateFormatters do
    include TemplateFormatters
    
    before do 
      Line.stub(:show) { "" }
    end
    
    describe :right do
      it "should right justify a string" do
        right("FOO", 5).should eq "  FOO"
      end
      it "should trim a string that's too long" do
        right("FOOBAR", 5).should eq "FOOBA"
      end
    end
  
    describe :left do
      it "should left justify a string" do
        left("FOO", 5).should eq "FOO  "
      end
      it "should trim a string that's too long" do
        left("FOOBAR", 5).should eq "FOOBA"
      end
    end
  
    describe :center do
      it "should center a string" do
        center("FOO", 5).should eq " FOO "
      end
      it "should trim a string that's too long" do
        center("FOOBAR", 5).should eq "FOOBA"
      end
    end
    
    describe :line_with_text do
      it "should render the line with text" do
        line_with_text("ABC").should eq "%x!-----------[ABC]-------------------------------------------------------%xn"
      end
    end
  end
end
