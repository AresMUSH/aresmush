require_relative "../../plugin_test_loader"

module AresMUSH
  module Login

    describe :validate_create_player do
      before do
        AresMUSH::Locale.stub(:translate).with("login.player_name_taken") { "player_name_taken" }
        AresMUSH::Locale.stub(:translate).with("login.password_too_short") { "password_too_short" }
        AresMUSH::Locale.stub(:translate).with("login.invalid_create_syntax") { "invalid_create_syntax" }

        @client = double(Client)
      end

      it "should fail if name is empty" do
        @client.should_receive(:emit_failure).with("invalid_create_syntax")
        Login.validate_create_player(@client, "", "password").should be_false
      end

      it "should fail if password is too short" do
        @client.should_receive(:emit_failure).with("password_too_short")
        Login.validate_create_player(@client, "name", "bar").should be_false
      end

      it "should fail if the player already exists" do
        Player.stub(:exists?).with("playername") { true }
        @client.should_receive(:emit_failure).with("player_name_taken")
        Login.validate_create_player(@client, "playername", "password").should be_false
      end

      it "should return true if everything's ok" do
        Player.stub(:exists?).with("playername") { false }
        Login.validate_create_player(@client, "playername", "password").should be_true
      end

    end

    describe :create_player do
      before do
        AresMUSH::Locale.stub(:translate).with("login.player_created", { :name => "playername" }) { "player_created" }
        @client = double(Client)
        @dispatcher = double(Dispatcher)
        Login.stub(:validate_create_player) { true }
        Player.stub(:create_player)
        @client.stub(:emit_success)
        @client.stub(:player=)
        @dispatcher.stub(:on_event)
      end

      it "should validate the inputs" do
        Login.should_receive(:validate_create_player).with(@client, "playername", "password") { false }
        Login.create_player(@client, "playername", "password", @dispatcher)
      end

      it "should not create the player if the inputs are invalid" do
        Login.should_receive(:validate_create_player).with(@client, "playername", "password") { false }
        Login.create_player(@client, "playername", "password", @dispatcher)
      end

      it "should create the player" do          
        Player.should_receive(:create_player).with("playername", "password")
        Login.create_player(@client, "playername", "password", @dispatcher)
      end

      it "should tell the player they're created" do
        @client.should_receive(:emit_success).with("player_created")
        Login.create_player(@client, "playername", "password", @dispatcher)
      end

      it "should set the player on the client" do
        player = mock
        Player.stub(:create_player).with("playername", "password") { player }
        @client.should_receive(:player=).with(player)
        Login.create_player(@client, "playername", "password", @dispatcher)
      end

      it "should dispatch the created event" do
        @dispatcher.should_receive(:on_event) do |type, args|
          type.should eq :player_created
          args[:client].should eq @client
        end
        Login.create_player(@client, "playername", "password", @dispatcher)
      end
    end      
  end
end

