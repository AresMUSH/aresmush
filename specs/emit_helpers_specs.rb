$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Formatters do
    describe :parse_pose do

      it "should parse a say for a string starting with a quote" do
        Locale.stub(:translate).with("object.say", :name => "Bob", :msg => "Hello.") { "hi" }
        Formatters.parse_pose("Bob", "\"Hello.").should eq "hi"
      end

      it "should parse a pose for a string starting with a colon" do
        Locale.stub(:translate).with("object.pose", :name => "Bob", :msg => "waves.") { "waves" }
        Formatters.parse_pose("Bob", ":waves.").should eq "waves"
      end

      it "should parse a semipose for a string starting with a semicolon" do
        Locale.stub(:translate).with("object.semipose", :name => "Bob", :msg => "'s cat.") { "cat" }
        Formatters.parse_pose("Bob", ";'s cat.").should eq "cat"
      end

      it "should parse an emit for a string starting with a backslash" do
        Formatters.parse_pose("Bob", "\\Whee").should eq "Whee"
      end

      it "should parse an emit for an unadorned string" do
        Formatters.parse_pose("Bob", "Whee").should eq "Whee"
      end

    end
  end
end