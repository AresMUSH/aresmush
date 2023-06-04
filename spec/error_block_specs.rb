

require "aresmush"

module AresMUSH
  describe "Error block" do
    before do
      @client = double
      allow(@client).to receive(:id) { "1" }
      stub_translate_for_testing
    end
    
    it "should catch an error and emit it to the client" do
      expect(@client).to receive(:emit_failure).with 'dispatcher.unexpected_error'
      val = AresMUSH.with_error_handling(@client, "TEST") do
        raise "An error"
      end
      expect(val).to eq false
    end
    
    it "should not emit anything on success" do
      expect(@client).to_not receive(:emit_failure)
      val = AresMUSH.with_error_handling(@client, "TEST") do
        x = 1 + 2
      end
      expect(val).to eq true
    end
    
    it "should not emit anything if client is nil" do
      val = AresMUSH.with_error_handling(nil, "TEST") do
        raise "An error"
      end
      expect(val).to eq false
    end
    
    it "should catch a double error" do
      expect(Global.logger).to receive(:error)
      expect(Global.logger).to receive(:error)
      client = double
      allow(client).to receive(:id) { 1 }
      expect(client).to receive(:emit_failure).and_raise("Double fault!")
      val = AresMUSH.with_error_handling(client, "TEST") do
        raise "An error"
      end
      expect(val).to eq false
    end
  end
end
