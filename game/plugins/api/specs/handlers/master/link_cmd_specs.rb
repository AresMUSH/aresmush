require_relative "../../../../plugin_test_loader"

module AresMUSH
  module Api
    describe LinkCmdHandler do
      include ApiHandlerTestHelper
      
      let(:expected_cmd) { "link" }
      
      before do
        @router = ApiMasterRouter.new
        @char = Character.new(name: "Star")
        Character.stub(:find_by_name).with("Star") { @char }
        SpecHelpers.stub_translate_for_testing
      end
      
      it "should fail if handle char not found" do
        Character.stub(:find_by_name).with("Star") { nil }
        cmd = ApiCommand.create_from("link @Star||ABC||Bob||LINK1")
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.invalid_handle")
      end
      
      it "should fail if character is already linked" do
        cmd = ApiCommand.create_from("link @Star||ABC||Bob||LINK1")
        @char.linked_characters["ABC"] = "Foo"
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.character_already_linked")
      end
      
      it "should fail if link code doesn't match" do
        cmd = ApiCommand.create_from("link @Star||ABC||Bob||LINK1")
        @char.temp_link_codes["ABC"] = "Foo"
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.invalid_link_code")
      end
      
      it "should succeed if link code matches" do
        cmd = ApiCommand.create_from("link @Star||ABC||Bob||LINK1")
        @char.temp_link_codes["ABC"] = "LINK1"
        @char.should_receive(:save!) { }
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.ok_status, "@Star")
        @char.linked_characters["ABC"].should include( "name" => "Bob", "game_id" => 1)
        @char.temp_link_codes["ABC"].should be_nil
      end
    end
  end
end