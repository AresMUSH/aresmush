require_relative "../../plugin_test_loader"

module AresMUSH
  module Api
    describe RegisterUpdateCmdHandler do
      before do
        @router = ApiMasterRouter.new
      end
      
      def check_response(response, expected_status, expected_args)
        response.status.should eq expected_status
        response.args_str.should eq expected_args
        response.command_name.should eq "register/update"
      end
      
      it "should fail if game not registered" do
        cmd = ApiCommand.create_from("register/update somewhere.com||101||A MUSH||Social||A cool MUSH")
        response = @router.route_command(-1, cmd)
        check_response(response, ApiResponse.error_status, "Game has not been registered.")
      end
      
      it "should fail if the port is not a number" do
        cmd = ApiCommand.create_from("register/update somewhere.com||x||A MUSH||Social||A cool MUSH")
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "Invalid port.")
      end
      
      it "should fail if the category is not valid" do
        cmd = ApiCommand.create_from("register/update somewhere.com||101||A MUSH||x||A cool MUSH")
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "Invalid category.")
      end
      
      it "should fail if the game is not found" do
        cmd = ApiCommand.create_from("register/update somewhere.com||101||A MUSH||Social||A cool MUSH")
        Api.stub(:get_destination).with(1) { nil }
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "Cannot find server info.")
      end
      
      it "should update the game" do
        cmd = ApiCommand.create_from("register/update somewhere.com||101||A MUSH||Social||A cool MUSH")
        game = double
        game.stub(:game_id) { 1 }
        Api.stub(:get_destination).with(1) { game }
        game.should_receive(:name=).with("A MUSH")
        game.should_receive(:host=).with("somewhere.com")
        game.should_receive(:port=).with(101)
        game.should_receive(:category=).with("Social")
        game.should_receive(:description=).with("A cool MUSH")
        game.should_receive(:save!)
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.ok_status, "")
      end
    end
  end
end