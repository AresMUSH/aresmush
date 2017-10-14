$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH
  describe "Error block" do
    before do
      @client = double
      @client.stub(:id) { "1" }
      SpecHelpers.stub_translate_for_testing
    end
    
    it "should catch an error and emit it to the client" do
      @client.should_receive(:emit_failure).with 'dispatcher.unexpected_error'
      val = AresMUSH.with_error_handling(@client, "TEST") do
        raise "An error"
      end
      val.should eq false
    end
    
    it "should not emit anything on success" do
      @client.should_not_receive(:emit_failure)
      val = AresMUSH.with_error_handling(@client, "TEST") do
        x = 1 + 2
      end
      val.should eq true
    end
    
    it "should not emit anything if client is nil" do
      val = AresMUSH.with_error_handling(nil, "TEST") do
        raise "An error"
      end
      val.should eq false
    end
    
    it "should catch a double error" do
      Global.logger.should_receive(:error)
      Global.logger.should_receive(:error)
      client = double
      client.stub(:id) { 1 }
      client.should_receive(:emit_failure).and_raise("Double fault!")
      val = AresMUSH.with_error_handling(client, "TEST") do
        raise "An error"
      end
      val.should eq false
    end
  end
end
