require_relative "../../../plugin_test_loader"

module AresMUSH
  module Api
    describe PingCmdHandler do
      include ApiHandlerTestHelper
      
      let(:expected_cmd) { "ping" }
      
      before do
        @router = ApiMasterRouter.new
        SpecHelpers.stub_translate_for_testing
      end
      
      it "should fail if the game is not found" do
        cmd = ApiCommand.create_from("ping A:B|C:D")
        Api.stub(:get_destination).with(1) { nil }
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.game_not_found")
      end
      
      it "should update the game's last ping time" do
        game = double
        Api.stub(:get_destination).with(1) { game }
        cmd = ApiCommand.create_from("ping A:B|C:D")
        time = Time.new(2007,11,1,15,25,20)
        Time.stub(:now) { time }
        game.should_receive(:last_ping=).with(time)
        game.should_receive(:save!)
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.ok_status, "")
      end
    end
  end
end