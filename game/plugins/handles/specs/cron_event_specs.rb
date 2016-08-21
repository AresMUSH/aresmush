require_relative "../../plugin_test_loader"

module AresMUSH
  module Handles
    describe HandlesEventHandler do
      include GlobalTestHelper
      include MockClient
      
      before do
        Global.stub(:read_config).with("api", "cron") { "x" }
        stub_global_objects
        Cron.stub(:is_cron_match?) { true }
      end
      
      it "should return a list of clients and handles" do
        # TODO!!!        
        #c1 = build_mock_client
        #c2 = build_mock_client
        
        #c1[:client].stub(:name) { "C1" }
        #c2[:client].stub(:name) { "C2" }
        #c1[:char].stub(:handle) { "H1" }
        #c2[:char].stub(:handle) { "H1" }
        
        #client_monitor.stub(:logged_in_clients) { [c1[:client], c2[:client]] }
        
        #@router.should_receive(:send_command) do |game_id, client, cmd|
        #  game_id.should eq ServerInfo.arescentral_game_id
        #  client.should be_nil
        #  cmd.command_name.should eq "ping"
        #  cmd.args_str.should eq "C1:H1||C2:H1"
        #end
        #@handler.on_cron_event(CronEvent.new("x"))
      end
      
      it "should return an empty list if nobody logged in" do
        # TODO!!!
        #client_monitor.stub(:logged_in_clients) { [] }
        #cmd = ApiCommand.create_from("ping")
        #@router.should_receive(:send_command) do |game_id, client, cmd|
        #  game_id.should eq ServerInfo.arescentral_game_id
        #  client.should be_nil
        #  cmd.command_name.should eq "ping"
        #  cmd.args_str.should eq ""
        #end
        #@handler.on_cron_event(CronEvent.new("x"))
      end
    end
  end
end