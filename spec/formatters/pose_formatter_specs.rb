$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe PoseFormatter do
        
    describe :format do

      it "should parse a say for a string starting with a quote" do
        allow(Locale).to receive(:translate).with("object.say", :name => "Bob", :msg => "Hello.") { "hi" }
        expect(PoseFormatter.format("Bob", "\"Hello.")).to eq "hi"
      end

      it "should parse a pose for a string starting with a colon" do
        allow(Locale).to receive(:translate).with("object.pose", :name => "Bob", :msg => "waves.") { "waves" }
        expect(PoseFormatter.format("Bob", ":waves.")).to eq "waves"
      end

      it "should parse a semipose for a string starting with a semicolon" do
        allow(Locale).to receive(:translate).with("object.semipose", :name => "Bob", :msg => "'s cat.") { "cat" }
        expect(PoseFormatter.format("Bob", ";'s cat.")).to eq "cat"
      end

      it "should default to a say" do
        allow(Locale).to receive(:translate).with("object.say", :name => "Bob", :msg => "Hello.") { "hi" }
        expect(PoseFormatter.format("Bob", "Hello.")).to eq "hi"
      end

    end
  end
end
