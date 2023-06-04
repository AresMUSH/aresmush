

require "aresmush"

module AresMUSH
  # Too much of a pain to test in isolation, so these are more of integration tests
  # with real Liquid templates.
  describe TemplateFormatters do
    include TemplateFormatters
    
    before do 
      allow(Line).to receive(:show) { "" }
    end
    
    describe :right do
      it "should right justify a string" do
        expect(right("FOO", 5)).to eq "  FOO"
      end
      it "should trim a string that's too long" do
        expect(right("FOOBAR", 5)).to eq "FOOBA"
      end
    end
  
    describe :left do
      it "should left justify a string" do
        expect(left("FOO", 5)).to eq "FOO  "
      end
      it "should trim a string that's too long" do
        expect(left("FOOBAR", 5)).to eq "FOOBA"
      end
    end
  
    describe :center do
      it "should center a string" do
        expect(center("FOO", 5)).to eq " FOO "
      end
      it "should trim a string that's too long" do
        expect(center("FOOBAR", 5)).to eq "FOOBA"
      end
    end    
  end
end
