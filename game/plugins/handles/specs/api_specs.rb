module AresMUSH
  module Handles
    describe Handles do
      include MockClient
      
      describe :link_character do
        before do
          mock_client = build_mock_client
          @client = mock_client[:client]
          @char = mock_client[:char]
          @router = double
          @router.stub(:is_master?) { false }
          Global.stub(:api_router) { @router }
          SpecHelpers.stub_translate_for_testing
        end        
        
        it "should fail if already has a handle" do
          @char.stub(:handle) { "Star" }
          @client.should_receive(:emit_failure).with("handles.character_already_linked")
          Handles.link_character(@client, "@Star", "LINK1")
        end
        
        it "should send command to central" do
          @client.stub(:name) { "Bob" }
          @char.stub(:handle) { nil }
          @char.stub(:api_character_id) { "ABC" }
          @client.should_receive(:emit_success).with("handles.sending_link_request")
          @router.should_receive(:send_command) do |game_id, client, cmd|
            game_id.should eq ServerInfo.arescentral_game_id
            client.should eq @client
            cmd.command_name.should eq "link"
            cmd.args_str.should eq "@Star||ABC||Bob||LINK1"
          end
          Handles.link_character(@client, "@Star", "LINK1")
        end
      end
      
      describe :get_profile do
        before do
          mock_client = build_mock_client
          @client = mock_client[:client]
          @char = mock_client[:char]
          @profile_char = double
          @router = double
          @router.stub(:is_master?) { false }
          Global.stub(:api_router) { @router }
          SpecHelpers.stub_translate_for_testing
        end        
        
        context "slave" do
          before do
            Character.stub(:find_all_by_name_or_id).with("Bob") { [ @profile_char ] }
            @profile_char.stub(:handle) { "@Nemo" }
            @profile_char.stub(:handle_visible_to?).with(@char) { true }
            @char.stub(:handle) { "@Star" }            
          end
        
          it "should be able to look up a handle directly" do
            @client.should_receive(:emit_success).with("handles.sending_profile_request")
            @router.should_receive(:send_command) do |game_id, client, cmd|
              game_id.should eq ServerInfo.arescentral_game_id
              client.should eq @client
              cmd.command_name.should eq "profile"
              cmd.args_str.should eq "@Dori||@Star"
            end
            Handles.get_profile(@client, "@Dori")
          end
        end
      end
    end
  end
end