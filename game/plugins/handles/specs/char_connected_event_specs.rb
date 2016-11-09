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
        @event = CharConnectedEvent.new(@client, @char)
        AresCentral::AresConnector.stub(:new) { @connector }
      end
      
      context "no handle" do
        it "should do nothing" do
          @char.stub(:handle) { nil }
          @connector.should_not_receive(:sync_handle)
          @handler.on_event(@event)
        end
      end
  
      context "linked" do       
        it "should set the preferences" do
          @handle = double
          @handle.stub(:handle_id) { 123 }
          @char.stub(:handle) { @handle }
          @char.stub(:name) { "Bob" }
          @char.stub(:id) { 111 }
          response = { "status" => "success", "data" => { "linked" => true, "autospace" => "x", "timezone" => "t", "friends" => "f", "quote_color" => "q", "page_color" => "pc", "page_autospace" => "ps" }}
          
          
          @connector.should_receive(:sync_handle).with(123, "Bob", 111) { AresCentral::AresResponse.new(response) }  
          @char.should_receive(:update).with({:pose_quote_color => "q"})
          @char.should_receive(:update).with({:pose_autospace => "x"})
          @char.should_receive(:update).with({:page_autospace => "ps"})
          @char.should_receive(:update).with({:page_color => "pc"})
          @char.should_receive(:update).with({:timezone => "t"})
          @handle.should_receive(:update).with(friends: "f")
          @client.should_receive(:emit_success).with("handles.handle_synced")
          @handler.on_event(@event)
        end
      end
      
      context "not linked" do
        it "should unlink the handle" do
          @handle = double
          @handle.stub(:handle_id) { 123 }
          @char.stub(:handle) { @handle }
          @char.stub(:name) { "Bob" }
          @char.stub(:id) { 111 }
          response = { "status" => "success", "data" => { "linked" => false }}
          
          @connector.should_receive(:sync_handle).with(123, "Bob", 111) { AresCentral::AresResponse.new(response) }  
          @char.should_not_receive(:autospace=)
          @handle.should_receive(:delete)
          @client.should_receive(:emit_success).with("handles.handle_no_longer_linked")
          @handler.on_event(@event)
        end
      end
    end
  end
end

