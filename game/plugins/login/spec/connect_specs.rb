require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
  
    describe Connect do
      before do
        @container = double(Container)
        @connect = Connect.new(@container)
        @client = double(Client)
        
        AresMUSH::Locale.stub(:translate).with("login.invalid_connect_syntax") { "invalid_connect_syntax" }
        AresMUSH::Locale.stub(:translate).with("login.invalid_password") { "invalid_password" }
      end
      
      describe :want_command? do
        it "doesn't want any commands" do
          cmd = mock
          @connect.want_command?(cmd).should be_false
        end
      end

      describe :want_anon_command? do
        it "wants the connect command" do
          cmd = mock
          cmd.stub(:root_is?).with("connect") { true }
          @connect.want_anon_command?(cmd).should be_true
        end

        it "doesn't want another command" do
          cmd = mock
          cmd.stub(:root_is?).with("connect") { false }
          @connect.want_anon_command?(cmd).should be_false
        end
      end
      
      # FAILURE
      describe :on_command do
        
        it "should fail if there's no password" do
          cmd = Command.new(@client, "connect Bob")
          @client.should_receive(:emit_failure).with("invalid_connect_syntax")
          @connect.on_command(@client, cmd)          
        end

        it "should fail if there's no name and password" do
          cmd = Command.new(@client, "connect")
          @client.should_receive(:emit_failure).with("invalid_connect_syntax")
          @connect.on_command(@client, cmd)          
        end

        it "should find only a single matching player" do
          cmd = Command.new(@client, "connect Bob password")
          Player.should_receive(:find_one_and_notify).with("Bob", @client) { nil }
          @connect.on_command(@client, cmd)          
        end
                          
        it "should fail if the passwords don't match" do
          cmd = Command.new(@client, "connect Bob password")
          found_player = mock
          Player.stub(:find_one_and_notify) { found_player }
          Player.stub(:compare_password).with(found_player, "password") { false }
          @client.should_receive(:emit_failure).with("invalid_password")
          @connect.on_command(@client, cmd)          
        end        
      end
      
      # SUCCESS
      describe :on_command do
        before do
          @found_player = mock
          @dispatcher = double(Dispatcher)
          @container.stub(:dispatcher) { @dispatcher }
          
          Player.stub(:find_one_and_notify){ @found_player }
          Player.stub(:compare_password).with(@found_player, "password") { true }  
          @dispatcher.stub(:on_event)  
          @client.stub(:player=)      
        end
        
        it "should compare passwords" do
          cmd = Command.new(@client, "connect Bob password")
          Player.should_receive(:compare_password).with(@found_player, "password")
          @connect.on_command(@client, cmd)          
        end
        
        it "should accept a multi-word password" do
          cmd = Command.new(@client, "connect Bob bob's password")
          Player.should_receive(:compare_password).with(@found_player, "bob's password")
          @connect.on_command(@client, cmd)          
        end
        
        it "should set the player on the client" do
          cmd = Command.new(@client, "connect Bob password")
          @client.should_receive(:player=).with(@found_player)
          @connect.on_command(@client, cmd)
        end

        it "should announce the player connected event" do
           cmd = Command.new(@client, "connect Bob password")
           @dispatcher.should_receive(:on_event) do |type, args|
             type.should eq :player_connected
             args[:client].should eq @client
           end
           @connect.on_command(@client, cmd)
        end
      end      
    end
  end
end