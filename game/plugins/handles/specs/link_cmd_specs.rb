module AresMUSH
  module Handles
    describe LinkCmdHandler do
      include ApiHandlerTestHelper
      
      let(:expected_cmd) { "link" }
      
      before do
        Global.api_router = ApiRouter.new(true)
        @char = Character.new(name: "Star")
        @char.stub(:friends) { [] }
        Character.stub(:find_by_name).with("Star") { @char }
        SpecHelpers.stub_translate_for_testing
      end
      
      it "should fail if handle char not found" do
        Character.stub(:find_by_name).with("Star") { nil }
        cmd = ApiCommand.create_from("link @Star||ABC||Bob||LINK1")
        response = Global.api_router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.invalid_handle")
      end
      
      it "should fail if character is already linked" do
        cmd = ApiCommand.create_from("link @Star||ABC||Bob||LINK1")
        @char.linked_characters["ABC"] = "Foo"
        response = Global.api_router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "handles.character_already_linked")
      end
      
      it "should fail if link code doesn't match" do
        cmd = ApiCommand.create_from("link @Star||ABC||Bob||LINK1")
        @char.temp_link_codes["ABC"] = "Foo"
        response = Global.api_router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "handles.invalid_link_code")
      end
      
      context "success" do
        before do
          @char.temp_link_codes["ABC"] = "LINK1"
          @char.should_receive(:save!) { }
        end
        
        it "should clear the link code" do
          cmd = ApiCommand.create_from("link @Star||ABC||Bob||LINK1")
          response = Global.api_router.route_command(1, cmd)
          check_response(response, ApiResponse.ok_status, "@Star")
          @char.linked_characters["ABC"].should include( "name" => "Bob", "game_id" => 1)
          @char.temp_link_codes["ABC"].should be_nil
        end
      end
    end
  end
end