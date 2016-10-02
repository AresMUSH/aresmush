require_relative "../../plugin_test_loader"

module AresMUSH
  module Handles
    describe CharConnectedEventHandler do
      
      before do
        @char = double
        @client = double
        SpecHelpers.setup_mock_client(@client, @char)
        SpecHelpers.stub_translate_for_testing
        @connector = double
        @handler = CharConnectedEventHandler.new
        @event = CharConnectedEvent.new(@client)
        AresCentral::AresConnector.stub(:new) { @connector }
      end
      
      context "no handle" do
        it "should do nothing" do
          @char.stub(:handle_id) { nil }
          @connector.should_not_receive(:sync_handle)
          @handler.on_event(@event)
        end
      end
  
      context "linked" do       
        it "should set the preferences" do
          @char.stub(:handle_id) { 123 }
          @char.stub(:name) { "Bob" }
          @char.stub(:id) { 111 }
          response = { "status" => "success", "data" => { "linked" => true, "autospace" => "x", "timezone" => "t", "friends" => "f" }}
          
          
          @connector.should_receive(:sync_handle).with(123, "Bob", 111) { AresCentral::AresResponse.new(response) }  
          @char.should_receive(:autospace=).with("x")
          @char.should_receive(:timezone=).with("t")
          Friends::Api.should_receive(:sync_handle_friends).with(@char, "f")
          @char.should_receive(:save)
          @client.should_receive(:emit_success).with("handles.handle_synced")
          @handler.on_event(@event)
        end
      end
      
      context "not linked" do
        it "should unlink the handle" do
          @char.stub(:handle_id) { 123 }
          @char.stub(:name) { "Bob" }
          @char.stub(:id) { 111 }
          response = { "status" => "success", "data" => { "linked" => false }}
          
          @connector.should_receive(:sync_handle).with(123, "Bob", 111) { AresCentral::AresResponse.new(response) }  
          @char.should_not_receive(:autospace=)
          @char.should_receive(:handle=).with(nil)
          @char.should_receive(:handle_id=).with(nil)
          @char.should_receive(:save)
          @client.should_receive(:emit_success).with("handles.handle_no_longer_linked")
          @handler.on_event(@event)
        end
      end
    end
  end
end

