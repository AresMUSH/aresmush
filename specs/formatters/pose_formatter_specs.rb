$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe PoseFormatter do
        
    describe :format do

      it "should parse a say for a string starting with a quote" do
        Locale.stub(:translate).with("object.say", :name => "Bob", :msg => "Hello.") { "hi" }
        PoseFormatter.format("Bob", "\"Hello.").should eq "hi"
      end

      it "should parse a pose for a string starting with a colon" do
        Locale.stub(:translate).with("object.pose", :name => "Bob", :msg => "waves.") { "waves" }
        PoseFormatter.format("Bob", ":waves.").should eq "waves"
      end

      it "should parse a semipose for a string starting with a semicolon" do
        Locale.stub(:translate).with("object.semipose", :name => "Bob", :msg => "'s cat.") { "cat" }
        PoseFormatter.format("Bob", ";'s cat.").should eq "cat"
      end

      it "should parse an emit for a string starting with a backslash" do
        PoseFormatter.format("Bob", "\\Whee").should eq "Whee"
      end
      
      it "should default to a say" do
        Locale.stub(:translate).with("object.say", :name => "Bob", :msg => "Hello.") { "hi" }
        PoseFormatter.format("Bob", "Hello.").should eq "hi"
      end

    end
  end
end