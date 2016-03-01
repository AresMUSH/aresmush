module AresMUSH
  module Api
    describe MasterRegisterCmdHandler do
      include ApiHandlerTestHelper
      
      let(:expected_cmd) { "register" }
      
      before do
        Global.api_router = ApiRouter.new(true)
        SpecHelpers.stub_translate_for_testing
      end
      
      it "should fail if game already registered" do
        cmd = ApiCommand.create_from("register somewhere.com||101||A MUSH||Social||A cool MUSH||http://www.somewhere.com||false")
        response = Global.api_router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.game_already_registered")
      end
      
      it "should fail if the port is not a number" do
        cmd = ApiCommand.create_from("register somewhere.com||x||A MUSH||Social||A cool MUSH||http://www.somewhere.com||false")
        response = Global.api_router.route_command(-1, cmd)
        check_response(response, ApiResponse.error_status, "api.invalid_port")
      end
      
      it "should fail if the category is not valid" do
        cmd = ApiCommand.create_from("register somewhere.com||101||A MUSH||x||A cool MUSH||http://www.somewhere.com||false")
        response = Global.api_router.route_command(-1, cmd)
        check_response(response, ApiResponse.error_status, "api.invalid_category")
      end
      
      it "should create the game" do
        cmd = ApiCommand.create_from("register somewhere.com||101||A MUSH||Social||A cool MUSH||http://www.somewhere.com||true")
        key = ApiCrypt.stub(:generate_key) { "ABC" }
        next_id = ServerInfo.stub(:next_id) { 3 }
        ServerInfo.should_receive(:create).with( 
          { :name => "A MUSH",
            :host => "somewhere.com",
            :port => 101,
            :category => "Social",
            :description => "A cool MUSH",
            :key => "ABC",
            :website => "http://www.somewhere.com",
            :game_open => true,
            :game_id => 3 })
        response = Global.api_router.route_command(-1, cmd)
        check_response(response, ApiResponse.ok_status, "3||ABC")
      end
    end
  end
end