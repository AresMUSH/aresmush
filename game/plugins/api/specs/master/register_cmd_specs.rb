require_relative "../../../plugin_test_loader"

module AresMUSH
  module Api
    describe MasterRegisterCmdHandler do
      before do
        @router = ApiMasterRouter.new
      end
      
      def check_response(response, expected_status, expected_args)
        response.status.should eq expected_status
        response.args_str.should eq expected_args
        response.command_name.should eq "register"
      end
      
      it "should fail if game already registered" do
        cmd = ApiCommand.create_from("register somewhere.com||101||A MUSH||Social||A cool MUSH")
        response = @router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "Game has already been registered.")
      end
      
      it "should fail if the port is not a number" do
        cmd = ApiCommand.create_from("register somewhere.com||x||A MUSH||Social||A cool MUSH")
        response = @router.route_command(-1, cmd)
        check_response(response, ApiResponse.error_status, "Invalid port.")
      end
      
      it "should fail if the category is not valid" do
        cmd = ApiCommand.create_from("register somewhere.com||101||A MUSH||x||A cool MUSH")
        response = @router.route_command(-1, cmd)
        check_response(response, ApiResponse.error_status, "Invalid category.")
      end
      
      it "should create the game" do
        cmd = ApiCommand.create_from("register somewhere.com||101||A MUSH||Social||A cool MUSH")
        key = ApiCrypt.stub(:generate_key) { "ABC" }
        next_id = ServerInfo.stub(:next_id) { 3 }
        ServerInfo.should_receive(:create).with( 
          { :name => "A MUSH",
            :host => "somewhere.com",
            :port => 101,
            :category => "Social",
            :description => "A cool MUSH",
            :key => "ABC",
            :game_id => 3 })
        response = @router.route_command(-1, cmd)
        check_response(response, ApiResponse.ok_status, "3||ABC")
      end
    end
  end
end