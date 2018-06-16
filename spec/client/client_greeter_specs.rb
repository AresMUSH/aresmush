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

      it "should send the welcome screen" do
        expect(File).to receive(:read).with("game/text/connect.txt", :encoding => "UTF-8") { "Ascii Art" }
        expect(@client).to receive(:emit).with("Ascii Art")
      end

      it "should send the ares welcome text" do
        expect(@client).to receive(:emit_ooc).with("client.welcome")
      end

    end
  end
end
