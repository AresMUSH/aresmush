$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe :parse_pose do
    before do
      @player = { "name" => "Bob" }
    end

    it "should parse a say for a string starting with a quote" do
      AresMUSH::Locale.stub(:translate).with("object.say", :name => "Bob", :msg => "Hello.") { "hi" }
      @player.parse_pose("\"Hello.").should eq "hi"
    end

    it "should parse a pose for a string starting with a colon" do
      AresMUSH::Locale.stub(:translate).with("object.pose", :name => "Bob", :msg => "waves.") { "waves" }
      @player.parse_pose(":waves.").should eq "waves"
    end

    it "should parse a semipose for a string starting with a semicolon" do
      AresMUSH::Locale.stub(:translate).with("object.semipose", :name => "Bob", :msg => "'s cat.") { "cat" }
      @player.parse_pose(";'s cat.").should eq "cat"
    end

    it "should parse an emit for a string starting with a backslash" do
      @player.parse_pose("\\Whee").should eq "Whee"
    end

    it "should parse an emit for an unadorned string" do
      @player.parse_pose("Whee").should eq "Whee"
    end

  end

end