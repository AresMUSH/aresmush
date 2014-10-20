require_relative "../../../../plugin_test_loader"

module AresMUSH
  module Api
    describe FriendCmdHandler do
      include ApiHandlerTestHelper
      
      let(:expected_cmd) { "friend/remove" }
      
      before do
        @router = ApiMasterRouter.new
        @char = Character.new(name: "Star")
        Character.stub(:find_by_name).with("Star") { @char }
      end
      
      it "should fail if handle char not found" do
        Character.stub(:find_by_name).with("Star") { nil }
        cmd = ApiCommand.create_from("friend/remove @Star||ABC||@Bob")
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "Invalid handle.")
      end
      
      it "should fail if character is not linked" do
        cmd = ApiCommand.create_from("friend/remove @Star||ABC||@Bob")
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "This character is not linked to your handle.")
      end
      
      it "should fail if remove friend fails" do
        @char.linked_characters["ABC"] = "Foo"
        cmd = ApiCommand.create_from("friend/remove @Star||ABC||@Bob")
        Friends.should_receive(:remove_friend).with(@char, "Bob") { "Friend problem." }
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "Friend problem.")
      end
      
      it "should succeed if add friend succeeds" do
        @char.linked_characters["ABC"] = "Foo"
        cmd = ApiCommand.create_from("friend/remove @Star||ABC||@Bob")
        Friends.should_receive(:remove_friend).with(@char, "Bob") { nil }
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.ok_status, "@Bob")
      end
    end
  end
end