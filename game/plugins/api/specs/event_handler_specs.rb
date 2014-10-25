require_relative "../../plugin_test_loader"

module AresMUSH
  module Api
    describe ApiEventHandler do
      include GlobalTestHelper
      include MockClient
      
      before do
        Global.stub(:config) { { "api" => { "cron" => "x" } }}
        stub_global_objects
        @handler = ApiEventHandler.new
        @router = double
        @router.stub(:is_master?) { false }
        Global.stub(:api_router) { @router }
        Cron.stub(:is_cron_match?) { true }
        Api.stub(:is_master?) { false }
      end
      
      it "should do nothing on the master game" do
        @router.stub(:is_master?) { true }
        Api.should_not_receive(:send_command)
      end
      
      it "should return a list of clients and handles" do
        c1 = build_mock_client
        c2 = build_mock_client
        
        c1[:client].stub(:name) { "C1" }
        c2[:client].stub(:name) { "C2" }
        c1[:char].stub(:handle) { "H1" }
        c2[:char].stub(:handle) { "H1" }
        
        client_monitor.stub(:logged_in_clients) { [c1[:client], c2[:client]] }
        
        @router.should_receive(:send_command) do |game_id, client, cmd|
          game_id.should eq ServerInfo.arescentral_game_id
          client.should be_nil
          cmd.command_name.should eq "ping"
          cmd.args_str.should eq "C1:H1||C2:H1"
        end
        @handler.on_cron_event(CronEvent.new("x"))
      end
      
      it "should return an empty list if nobody logged in" do
        client_monitor.stub(:logged_in_clients) { [] }
        cmd = ApiCommand.create_from("ping")
        @router.should_receive(:send_command) do |game_id, client, cmd|
          game_id.should eq ServerInfo.arescentral_game_id
          client.should be_nil
          cmd.command_name.should eq "ping"
          cmd.args_str.should eq ""
        end
        @handler.on_cron_event(CronEvent.new("x"))
      end
    end
  end
end