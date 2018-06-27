$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe ClientGreeter do

    before do
      @client = double.as_null_object
      stub_translate_for_testing
      allow(File).to receive(:read)      
    end

    describe :connected do
      after do
        ClientGreeter.greet(@client)  
      end

      it "should send a randomly selected welcome screen" do
        expect(ClientGreeter::CONNECT_FILES).to receive(:sample).and_return("game/text/connect.txt")
        expect(File).to receive(:read).with("game/text/connect.txt", :encoding => "UTF-8") { "Ascii Art" }
        expect(@client).to receive(:emit).with("Ascii Art")
      end

      it "should send the ares welcome text" do
        expect(@client).to receive(:emit_ooc).with("client.welcome")
      end

    end
  end
end
