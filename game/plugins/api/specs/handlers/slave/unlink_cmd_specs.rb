require_relative "../../../../plugin_test_loader"

module AresMUSH
  module Api
    describe UnlinkCmdHandler do
      include ApiHandlerTestHelper
      
      let(:expected_cmd) { "unlink" }
      
      before do
        @router = ApiSlaveRouter.new
        @char = Character.new(name: "Bob", handle: "@Star")
        @char.stub(:api_character_id) { "ABC" }
        Character.stub(:all) { [ @char ] }
      end
      
      it "should fail if handle char not found" do
        cmd = ApiCommand.create_from("unlink @Star||XXX")
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "Invalid character ID.")
      end
      
      it "should fail if character doesn't have that handle" do
        cmd = ApiCommand.create_from("unlink @XXX||ABC")
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "This character is not linked to that handle.")
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