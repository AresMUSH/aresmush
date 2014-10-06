require_relative "../../../plugin_test_loader"

module AresMUSH
  module Api
    describe MasterRegisterCmdHandler do
      before do
        @router = ApiMasterRouter.new
      end
      
      it "should fail if game already registered" do
        cmd_str = "register somewhere.com||101||A MUSH||Social||A cool MUSH"
        @router.route_command(1, cmd_str).should eq "register Game has already been registered."
      end
      
      it "should fail if the port is not a number" do
        cmd_str = "register somewhere.com||x||A MUSH||Social||A cool MUSH"
        @router.route_command(-1, cmd_str).should eq "register Invalid port."
      end
      
      it "should fail if the category is not valid" do
        cmd_str = "register somewhere.com||101||A MUSH||x||A cool MUSH"
        @router.route_command(-1, cmd_str).should eq "register Invalid category."
      end
      
      it "should create the game" do
        cmd_str = "register somewhere.com||101||A MUSH||Social||A cool MUSH"
        key = Api.stub(:generate_key) { "ABC" }
        next_id = ServerInfo.stub(:next_id) { 3 }
        ServerInfo.should_receive(:create).with( 
          { :name => "A MUSH",
            :host => "somewhere.com",
            :port => 101,
            :category => "Social",
            :description => "A cool MUSH",
            :key => "ABC",
            :game_id => 3 })
        @router.route_command(-1, cmd_str).should eq "register 3||ABC"
      end
    end
  end
end