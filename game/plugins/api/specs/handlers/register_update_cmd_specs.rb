module AresMUSH
  module Api
    describe RegisterUpdateCmdHandler do
      include ApiHandlerTestHelper
      
      let(:expected_cmd) { "register/update" }
       
      before do
        Global.api_router = ApiRouter.new(true)
        SpecHelpers.stub_translate_for_testing
      end
      
      it "should fail if game not registered" do
        cmd = ApiCommand.create_from("register/update somewhere.com||101||A MUSH||Social||A cool MUSH||http://www.somewhere.com||no")
        response = Global.api_router.route_command(-1, cmd)
        check_response(response, ApiResponse.error_status, "api.game_not_registered")
      end
      
      it "should fail if the port is not a number" do
        cmd = ApiCommand.create_from("register/update somewhere.com||x||A MUSH||Social||A cool MUSH||http://www.somewhere.com||no")
        response = Global.api_router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.invalid_port")
      end
      
      it "should fail if the category is not valid" do
        cmd = ApiCommand.create_from("register/update somewhere.com||101||A MUSH||x||A cool MUSH||http://www.somewhere.com||no")
        response = Global.api_router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.invalid_category")
      end
      
      it "should fail if the game is not found" do
        cmd = ApiCommand.create_from("register/update somewhere.com||101||A MUSH||Social||A cool MUSH||http://www.somewhere.com||no")
        ServerInfo.stub(:find_by_dest_id).with(1) { nil }
        response = Global.api_router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.game_not_found")
      end
      
      it "should update the game" do
        cmd = ApiCommand.create_from("register/update somewhere.com||101||A MUSH||Social||A cool MUSH||http://www.somewhere.com||yes")
        game = double
        game.stub(:game_id) { 1 }
        ServerInfo.stub(:find_by_dest_id).with(1) { game }
        game.should_receive(:name=).with("A MUSH")
        game.should_receive(:host=).with("somewhere.com")
        game.should_receive(:port=).with(101)
        game.should_receive(:category=).with("Social")
        game.should_receive(:description=).with("A cool MUSH")
        game.should_receive(:website=).with("http://www.somewhere.com")
        game.should_receive(:game_open=).with("yes")
        game.should_receive(:last_ping=)
        game.should_receive(:save!)
        response = Global.api_router.route_command(1, cmd)
        check_response(response, ApiResponse.ok_status, "")
      end
    end
  end
end