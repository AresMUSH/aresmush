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
      end
      
      it "should fail if handle char not found" do
        Character.stub(:find_by_name).with("Star") { nil }
        cmd = ApiCommand.create_from("link @Star||ABC||Bob||LINK1")
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "Invalid handle.")
      end
      
      it "should fail if character is already linked" do
        cmd = ApiCommand.create_from("link @Star||ABC||Bob||LINK1")
        @char.linked_characters["ABC"] = "Foo"
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "This character is already linked to your handle.")
      end
      
      it "should fail if link code doesn't match" do
        cmd = ApiCommand.create_from("link @Star||ABC||Bob||LINK1")
        @char.temp_link_codes["ABC"] = "Foo"
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "Invalid link code.  Please check the code and try again.")
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