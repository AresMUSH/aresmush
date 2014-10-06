require_relative "../../../plugin_test_loader"

module AresMUSH
  module Api
    describe SlaveRegisterResponseHandler do
      before do
        @router = ApiSlaveRouter.new
        @client = double
        @game = double
        Game.stub(:master) { @game }
      end
      
      it "should fail if game id is invalid" do
        cmd_str = "register x||y"
        expect { @router.route_response(@client, cmd_str) }.to raise_error(ArgumentError)
      end
      
      it "should fail if there's an error string" do
        cmd_str = "register something wrong"
        expect { @router.route_response(@client, cmd_str) }.to raise_error("Registration error: something wrong")
      end
      
      context "success" do
        
        before do
          @game.stub(:save)
          @game.stub(:api_game_id=)
          @central = double
          Api.stub(:get_destination).with(0) { @central }
          @central.stub(:save)
          @central.stub(:key=)
        end
        
        it "should update and save the game info" do
          cmd_str = "register 2||x"
          @game.should_receive(:api_game_id=).with(2)
          @game.should_receive(:save)
          @router.route_response(@client, cmd_str)
        end
      
        it "should update and save the Ares Central key" do
          cmd_str = "register 2||x"
          @central.should_receive(:key=).with("x")
          @central.should_receive(:save)
          @router.route_response(@client, cmd_str)
        end
      
        it "should fail if Ares Central not found" do
          cmd_str = "register 2||x"
          Api.stub(:get_destination).with(0) { nil }
          expect { @router.route_response(@client, cmd_str) }.to raise_error("Can't find AresCentral server info.")
        end
      end
    end
  end
end