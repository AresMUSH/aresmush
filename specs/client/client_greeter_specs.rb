$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ClientGreeter do

    before do
      Global.stub(:config) { { "connect" => { "welcome_text" => "game welcome", "welcome_screen" => "Ascii Art"} } }
      @client = double.as_null_object
      SpecHelpers.stub_translate_for_testing
    end

    describe :connected do
      after do
        ClientGreeter.greet(@client)        
      end

      it "should send the welcome screen" do
        @client.should_receive(:emit).with("Ascii Art")
      end

      it "should send the game welcome text" do
        @client.should_receive(:emit_ooc).with("client.welcome")
      end

      it "should send the server welcome text" do
        @client.should_receive(:emit_ooc).with("game welcome")
      end
    end
  end
end