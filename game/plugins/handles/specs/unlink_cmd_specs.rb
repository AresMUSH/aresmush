module AresMUSH
  module Handles
    describe UnlinkCmdHandler do
      include ApiHandlerTestHelper
      
      let(:expected_cmd) { "unlink" }
      
      before do
        @router = Api::ApiSlaveRouter.new
        @char = Character.new(name: "Bob", handle: "@Star")
        @char.stub(:api_character_id) { "ABC" }
        Character.stub(:all) { [ @char ] }
        SpecHelpers.stub_translate_for_testing
      end
      
      it "should fail if handle char not found" do
        cmd = ApiCommand.create_from("unlink @Star||XXX")
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.invalid_char_id")
      end
      
      it "should fail if character doesn't have that handle" do
        cmd = ApiCommand.create_from("unlink @XXX||ABC")
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.character_not_linked")
      end
      
      it "should clear the handle" do
        cmd = ApiCommand.create_from("unlink @Star||ABC")
        @char.should_receive(:save!) { }
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.ok_status, "")
        @char.handle.should be_nil
      end
    end
  end
end