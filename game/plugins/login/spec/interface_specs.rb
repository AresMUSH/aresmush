require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
    describe :validate_player_name do
      before do
        AresMUSH::Locale.stub(:translate).with("login.player_name_taken") { "player_name_taken" }
        AresMUSH::Locale.stub(:translate).with("login.invalid_create_syntax") { "invalid_create_syntax" }

        @client = double(Client)
      end
      
      it "should fail if name is empty" do
        @client.should_receive(:emit_failure).with("invalid_create_syntax")
        Login.validate_player_name(@client, "").should be_false
      end
      
      it "should fail if the player already exists" do
        Player.stub(:exists?).with("playername") { true }
        @client.should_receive(:emit_failure).with("player_name_taken")
        Login.validate_player_name(@client, "playername").should be_false
      end

      it "should return true if everything's ok" do
        Player.stub(:exists?).with("playername") { false }
        Login.validate_player_name(@client, "playername").should be_true
      end
    end
    
    describe :validate_player_password do
      before do
        AresMUSH::Locale.stub(:translate).with("login.password_too_short") { "password_too_short" }
        @client = double(Client)
      end

      it "should fail if password is too short" do
        @client.should_receive(:emit_failure).with("password_too_short")
        Login.validate_player_password(@client, "bar").should be_false
      end

      it "should return true if everything's ok" do
        Player.stub(:exists?).with("playername") { false }
        Login.validate_player_password(@client, "password").should be_true
      end
    end
  end
end

