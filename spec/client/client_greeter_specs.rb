$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ClientGreeter do

    before do
      @client = double.as_null_object
      SpecHelpers.stub_translate_for_testing
      File.stub(:read)      
    end

    describe :connected do
      after do
        ClientGreeter.greet(@client)  
      end

      it "should send the welcome screen" do
        File.should_receive(:read).with("game/files/connect.txt", :encoding => "UTF-8") { "Ascii Art" }
        @client.should_receive(:emit).with("Ascii Art")
      end

      it "should send the ares welcome text" do
        @client.should_receive(:emit_ooc).with("client.welcome")
      end

    end
  end
end