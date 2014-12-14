module AresMUSH
  module Handles
    describe LinkResponseHandler do
      include MockClient
      
      before do
        Global.api_router = ApiRouter.new(false)
        mock_client = build_mock_client
        @client = mock_client[:client]
        @char = mock_client[:char]
        SpecHelpers.stub_translate_for_testing
      end
      
      context "success" do
        before do
          @char.should_receive(:save!)
          @client.should_receive(:emit_success).with("handles.link_successful")
          @client.should_receive(:emit_ooc).with("handles.privacy_set")
          @char.stub(:handle=)
          @char.stub(:handle_privacy=)
          @char.stub(:handle_sync=)
          Api.stub(:sync_char_with_master)
        end
        
        it "should set the handle" do
          response = ApiResponse.new("link", ApiResponse.ok_status, "@Star")
          @char.should_receive(:handle=).with("@Star")
          Global.api_router.route_response(@client, response)
        end
        
        it "should set the handle privacy and sync to defaults" do
          response = ApiResponse.new("link", ApiResponse.ok_status, "@Star")
          @char.should_receive(:handle_privacy=).with(Handles.privacy_friends)
          @char.should_receive(:handle_sync=).with(true)
          Global.api_router.route_response(@client, response)
        end
        
        it "should immediately sync the char with master" do
          response = ApiResponse.new("link", ApiResponse.ok_status, "@Star")
          Api.should_receive(:sync_char_with_master).with(@client)
          Global.api_router.route_response(@client, response)
        end
          
      end 
    end
  end
end