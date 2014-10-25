module AresMUSH
  module Friends
    describe :Friends do
      include MockClient
    
      describe :add_handle_friend do
        before do
          mock_client = build_mock_client
          @client = mock_client[:client]
          @char = mock_client[:char]
          @router = double
          @router.stub(:is_master?) { false }
          Global.stub(:api_router) { @router }
          SpecHelpers.stub_translate_for_testing
        end
      
        it "should not work on master" do
          @router.stub(:is_master?) { true }
          @client.should_receive(:emit_failure).with("friends.cant_manage_handle_friends_on_master")
          Friends.add_handle_friend(@client, "@ Bob")
        end
      
        it "should fail if no handle" do
          @char.stub(:handle) { nil }
          @client.should_receive(:emit_failure).with("api.no_handle_set")
          Friends.add_handle_friend(@client, "@Bob")
        end
      
        it "should send command to central" do
          @char.stub(:handle) { "@Star" }
          @char.stub(:api_character_id) { "ABC" }
          @client.should_receive(:emit_success).with("friends.sending_friends_request")
          @router.should_receive(:send_command) do |game_id, client, cmd|
            game_id.should eq ServerInfo.arescentral_game_id
            client.should eq @client
            cmd.command_name.should eq "friend/add"
            cmd.args_str.should eq "@Star||ABC||@Bob"
          end
          Friends.add_handle_friend(@client, "@Bob")
        end
      end
    
      describe :remove_handle_friend do
        before do
          mock_client = build_mock_client
          @client = mock_client[:client]
          @char = mock_client[:char]
          @router = double
          @router.stub(:is_master?) { false }
          Global.stub(:api_router) { @router }
          SpecHelpers.stub_translate_for_testing
        end
      
        it "should not work on master" do
          @router.stub(:is_master?) { true }
          @client.should_receive(:emit_failure).with("friends.cant_manage_handle_friends_on_master")
          Friends.remove_handle_friend(@client, "@Bob")
        end
      
        it "should fail if no handle" do
          @char.stub(:handle) { nil }
          @client.should_receive(:emit_failure).with("api.no_handle_set")
          Friends.remove_handle_friend(@client, "@Bob")
        end
      
        it "should send command to central" do
          @char.stub(:handle) { "@Star" }
          @char.stub(:api_character_id) { "ABC" }
          @client.should_receive(:emit_success).with("friends.sending_friends_request")
          @router.should_receive(:send_command) do |game_id, client, cmd|
            game_id.should eq ServerInfo.arescentral_game_id
            client.should eq @client
            cmd.command_name.should eq "friend/remove"
            cmd.args_str.should eq "@Star||ABC||@Bob"
          end
          Friends.remove_handle_friend(@client, "@Bob")
        end
      end
    end
  end
end