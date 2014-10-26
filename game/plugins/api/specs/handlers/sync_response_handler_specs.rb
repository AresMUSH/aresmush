module AresMUSH
  module Api
    describe SyncResponseHandler do
      include MockClient
      
      before do
        Global.api_router = ApiRouter.new(false)
        mock_client = build_mock_client
        @client = mock_client[:client]
        @char = mock_client[:char]
        @client.stub(:name) { "Nemo" }
        SpecHelpers.stub_translate_for_testing
      end
        
      it "should set the handle friends" do
        response = ApiResponse.new("sync", ApiResponse.ok_status, "F1 F2")
        @char.should_receive(:handle_friends=).with(["F1", "F2"])
        @char.should_receive(:save!)
        @client.should_receive(:emit_ooc).with("api.handle_synced")
        Global.api_router.route_response(@client, response)
      end
    end 
  end
end