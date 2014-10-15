require_relative "../../plugin_test_loader"

module AresMUSH
  module Api
    describe PingCmdHandler do
      include GlobalTestHelper
      include MockClient
      
      before do
        @router = ApiSlaveRouter.new
        stub_global_objects
      end
      
      it "should return a list of clients and handles" do
        c1 = build_mock_client
        c2 = build_mock_client
        
        c1[:client].stub(:name) { "C1" }
        c2[:client].stub(:name) { "C2" }
        c1[:char].stub(:handle) { "H1" }
        c2[:char].stub(:handle) { "H1" }
        
        client_monitor.stub(:logged_in_clients) { [c1[:client], c2[:client]] }
        cmd = ApiCommand.create_from("ping")
        response = @router.route_command(1, cmd)
        response.status.should eq ApiResponse.ok_status
        response.args_str.should eq "C1:H1||C2:H1"
        response.command_name.should eq "ping"
      end
      
      it "should return an empty list if nobody logged in" do
        client_monitor.stub(:logged_in_clients) { [] }
        cmd = ApiCommand.create_from("ping")
        response = @router.route_command(1, cmd)
        response.status.should eq ApiResponse.ok_status
        response.args_str.should eq ""
        response.command_name.should eq "ping"
      end
    end
  end
end