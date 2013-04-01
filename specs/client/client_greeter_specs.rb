$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ClientGreeter do

    before do
      AresMUSH::Locale.stub(:translate).with("client.welcome") { "welcome" }
      @config = { "welcome_text" => "game welcome", "welcome_screen" => "Ascii Art"}
      @client = mock.as_null_object
    end

    describe :connected do
      after do
        ClientGreeter.greet(@client, @config)        
      end

      it "should send the welcome screen" do
        @client.should_receive(:emit).with("Ascii Art")
      end

      it "should send the game welcome text" do
        @client.should_receive(:emit_ooc).with("welcome")
      end

      it "should send the server welcome text" do
        @client.should_receive(:emit_ooc).with("game welcome")
      end
    end
  end
end