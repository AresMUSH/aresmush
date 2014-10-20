module AresMUSH
  module Api
    describe Api do
      include MockClient
      
      describe :add_handle_friend do
        before do
          mock_client = build_mock_client
          @client = mock_client[:client]
          @char = mock_client[:char]
          Api.stub(:is_master?) { false }
          SpecHelpers.stub_translate_for_testing
        end
        
        it "should not work on master" do
          Api.stub(:is_master?) { true }
          @client.should_receive(:emit_failure).with("api.cant_manage_handle_friends_on_master")
          Api.add_handle_friend(@client, "@Bob")
        end
        
        it "should fail if no handle" do
          @char.stub(:handle) { nil }
          @client.should_receive(:emit_failure).with("api.character_not_linked")
          Api.add_handle_friend(@client, "@Bob")
        end
        
        it "should send command to central" do
          @char.stub(:handle) { "@Star" }
          @char.stub(:api_character_id) { "ABC" }
          @client.should_receive(:emit_success).with("api.sending_friends_request")
          Api.should_receive(:send_command) do |game_id, client, cmd|
            game_id.should eq ServerInfo.arescentral_game_id
            client.should eq @client
            cmd.command_name.should eq "friend/add"
            cmd.args_str.should eq "@Star||ABC||@Bob"
          end
          Api.add_handle_friend(@client, "@Bob")
        end
      end
      
      describe :remove_handle_friend do
        before do
          mock_client = build_mock_client
          @client = mock_client[:client]
          @char = mock_client[:char]
          Api.stub(:is_master?) { false }
          SpecHelpers.stub_translate_for_testing
        end
        
        it "should not work on master" do
          Api.stub(:is_master?) { true }
          @client.should_receive(:emit_failure).with("api.cant_manage_handle_friends_on_master")
          Api.remove_handle_friend(@client, "@Bob")
        end
        
        it "should fail if no handle" do
          @char.stub(:handle) { nil }
          @client.should_receive(:emit_failure).with("api.character_not_linked")
          Api.remove_handle_friend(@client, "@Bob")
        end
        
        it "should send command to central" do
          @char.stub(:handle) { "@Star" }
          @char.stub(:api_character_id) { "ABC" }
          @client.should_receive(:emit_success).with("api.sending_friends_request")
          Api.should_receive(:send_command) do |game_id, client, cmd|
            game_id.should eq ServerInfo.arescentral_game_id
            client.should eq @client
            cmd.command_name.should eq "friend/remove"
            cmd.args_str.should eq "@Star||ABC||@Bob"
          end
          Api.remove_handle_friend(@client, "@Bob")
        end
      end
      
      describe :link_character do
        before do
          mock_client = build_mock_client
          @client = mock_client[:client]
          @char = mock_client[:char]
          Api.stub(:is_master?) { false }
          SpecHelpers.stub_translate_for_testing
        end        
        
        it "should fail if already has a handle" do
          @char.stub(:handle) { "Star" }
          @client.should_receive(:emit_failure).with("api.character_already_linked")
          Api.link_character(@client, "@Star", "LINK1")
        end
        
        it "should send command to central" do
          @client.stub(:name) { "Bob" }
          @char.stub(:handle) { nil }
          @char.stub(:api_character_id) { "ABC" }
          @client.should_receive(:emit_success).with("api.sending_link_request")
          Api.should_receive(:send_command) do |game_id, client, cmd|
            game_id.should eq ServerInfo.arescentral_game_id
            client.should eq @client
            cmd.command_name.should eq "link"
            cmd.args_str.should eq "@Star||ABC||Bob||LINK1"
          end
          Api.link_character(@client, "@Star", "LINK1")
        end
      end
    end
  end
end