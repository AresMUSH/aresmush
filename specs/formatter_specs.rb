$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Formatter do
    describe :parse_pose do

      it "should parse a say for a string starting with a quote" do
        Locale.stub(:translate).with("object.say", :name => "Bob", :msg => "Hello.") { "hi" }
        Formatter.parse_pose("Bob", "\"Hello.").should eq "hi"
      end

      it "should parse a pose for a string starting with a colon" do
        Locale.stub(:translate).with("object.pose", :name => "Bob", :msg => "waves.") { "waves" }
        Formatter.parse_pose("Bob", ":waves.").should eq "waves"
      end

      it "should parse a semipose for a string starting with a semicolon" do
        Locale.stub(:translate).with("object.semipose", :name => "Bob", :msg => "'s cat.") { "cat" }
        Formatter.parse_pose("Bob", ";'s cat.").should eq "cat"
      end

      it "should parse an emit for a string starting with a backslash" do
        Formatter.parse_pose("Bob", "\\Whee").should eq "Whee"
      end

      it "should parse an emit for an unadorned string" do
        Formatter.parse_pose("Bob", "Whee").should eq "Whee"
      end

    end
    
    
    describe :perform_subs do
      before do
        @enactor = { "name" => "Bob" }
      end

      it "should replace %r and %R with linebreaks" do
        Formatter.perform_subs("Test%rline%Rline2", nil).should eq "Test\nline\nline2"
      end

      it "should replace %t and %T with 5 spaces" do
        Formatter.perform_subs("Test%tTest2%TTest3", nil).should eq "Test     Test2     Test3"
      end

      it "should replace %~ with the unicde marker" do
        Formatter.perform_subs("Test%~Test", nil).should eq "Test\u2682Test"
      end      
    end
  end
end