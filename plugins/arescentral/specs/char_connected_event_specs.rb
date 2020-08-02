require_relative "../../plugin_test_loader"

module AresMUSH
  module AresCentral
    describe CharConnectedEventHandler do
      
      before do
        @char = double
        @client = double
        setup_mock_client(@client, @char)
        stub_translate_for_testing
        @connector = double
        @handler = CharConnectedEventHandler.new
        allow(AresCentral).to receive(:is_registered?) { true }
        @char_id = 111
        allow(Character).to receive(:[]).with(@char_id) { @char }
        
        @event = CharConnectedEvent.new(@client, @char_id)
        allow(AresCentral::AresConnector).to receive(:new) { @connector }
      end
      
      context "no handle" do
        it "should do nothing" do
          allow(@char).to receive(:handle) { nil }
          expect(@connector).to_not receive(:sync_handle)
          @handler.on_event(@event)
        end
      end
  
      context "linked" do       
        it "should set the preferences" do
          @handle = double
          allow(@handle).to receive(:handle_id) { 123 }
          allow(@char).to receive(:handle) { @handle }
          allow(@char).to receive(:name) { "Bob" }
          allow(@char).to receive(:id) { 111 }
          response = { "status" => "success", "data" => { "linked" => true, "autospace" => "x", "timezone" => "t", "friends" => "f", "quote_color" => "q", "page_color" => "pc", "page_autospace" => "ps", "ascii_only" => true, "screen_reader" => true, "profile" => "handle profile" }}
          
          
          expect(@connector).to receive(:sync_handle).with(123, "Bob", 111) { AresCentral::AresResponse.new(response) }  
          expect(@char).to receive(:update).with({:pose_quote_color => "q"})
          expect(@char).to receive(:update).with({:pose_autospace => "x"})
          expect(@char).to receive(:update).with({:page_autospace => "ps"})
          expect(@char).to receive(:update).with({:page_color => "pc"})
          expect(@char).to receive(:update).with({:timezone => "t"})
          expect(@char).to receive(:update).with(ascii_mode_enabled: true)
          expect(@char).to receive(:update).with(screen_reader: true)
          expect(@handle).to receive(:update).with(profile: "handle profile")
          expect(@handle).to receive(:update).with(friends: "f")
          expect(@client).to receive(:emit_success).with("arescentral.handle_synced")
          @handler.on_event(@event)
        end
      end
      
      context "not linked" do
        it "should unlink the handle foobar" do
          @handle = double
          allow(@handle).to receive(:handle_id) { 123 }
          allow(@char).to receive(:handle) { @handle }
          allow(@char).to receive(:name) { "Bob" }
          allow(@char).to receive(:id) { 111 }
          response = { "status" => "success", "data" => { "linked" => false }}
          
          expect(@connector).to receive(:sync_handle).with(123, "Bob", 111) { AresCentral::AresResponse.new(response) }  
          expect(@char).to_not receive(:autospace=)
          expect(@handle).to receive(:delete)
          expect(@client).to receive(:emit_failure).with("arescentral.handle_no_longer_linked")
          @handler.on_event(@event)
        end
      end
    end
  end
end

