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
        
      context "success" do
        before do
          @char.should_receive(:save!)
          @client.should_receive(:emit_ooc).with("api.handle_synced")
          @char.stub(:handle_friends=)
          @char.stub(:autospace=)
          @char.stub(:timezone=)
        end
        
        it "should set the preferences if sync is on" do
          @char.stub(:handle_sync) { true }
          response = ApiResponse.new("sync", ApiResponse.ok_status, "F1 F2||as||tz")
          @char.should_receive(:handle_friends=).with(["F1", "F2"])
          @char.should_receive(:autospace=).with("as")
          @char.should_receive(:timezone=).with("tz")
          Global.api_router.route_response(@client, response)
        end
        
        it "should only set friends if sync is off" do
          @char.stub(:handle_sync) { false }
          response = ApiResponse.new("sync", ApiResponse.ok_status, "F1 F2||as||tz")
          @char.should_receive(:handle_friends=).with(["F1", "F2"])
          @char.should_not_receive(:autospace=)
          @char.should_not_receive(:timezone=)
          Global.api_router.route_response(@client, response)
        end
      end
    end 
  end
end