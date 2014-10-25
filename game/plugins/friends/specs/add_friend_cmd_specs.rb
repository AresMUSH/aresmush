module AresMUSH
  module Friends
    describe FriendCmdHandler do
      include ApiHandlerTestHelper
      
      let(:expected_cmd) { "friend/add" }
      
      before do
        Api.stub(:is_master?) { true }
        @router = Api::ApiRouter.new
        @char = Character.new(name: "Star")
        Character.stub(:find_by_name).with("Star") { @char }
        SpecHelpers.stub_translate_for_testing
      end
      
      it "should fail if handle char not found" do
        Character.stub(:find_by_name).with("Star") { nil }
        cmd = ApiCommand.create_from("friend/add @Star||ABC||@Bob")
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.invalid_handle")
      end
      
      it "should fail if character is not linked" do
        cmd = ApiCommand.create_from("friend/add @Star||ABC||@Bob")
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.character_not_linked")
      end
      
      it "should fail if add friend fails" do
        @char.linked_characters["ABC"] = "Foo"
        cmd = ApiCommand.create_from("friend/add @Star||ABC||@Bob")
        Friends.should_receive(:add_friend).with(@char, "Bob") { "Friend problem." }
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "Friend problem.")
      end
      
      it "should succeed if add friend succeeds" do
        @char.linked_characters["ABC"] = "Foo"
        cmd = ApiCommand.create_from("friend/add @Star||ABC||@Bob")
        Friends.should_receive(:add_friend).with(@char, "Bob") { nil }
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.ok_status, "@Bob")
      end
    end
  end
end