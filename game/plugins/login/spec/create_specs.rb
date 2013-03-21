require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
    describe Create do
      before do
        AresMUSH::Locale.stub(:translate).with("login.invalid_create_syntax") { "invalid_create_syntax" }
      end
      
      describe :want_anon_command? do
        it "should want an anon command if the root is 'create'" do
          cmd = double(Command)
          cmd.stub(:root_is?).with("create") { true }
          create = Create.new(nil)
          create.want_anon_command?(cmd).should eq true
        end

        it "should not want an anon command if the root something else" do
          cmd = double(Command)
          cmd.stub(:root_is?).with("create") { false }
          create = Create.new(nil)
          create.want_anon_command?(cmd).should eq false
        end
      end

      describe :want_command? do
        it "should not want logged in commands" do
          cmd = double(Command)
          create = Create.new(nil)
          create.want_command?(cmd).should eq false
        end
      end
      
      describe :on_command do
        before do
          @client = double(Client)
          @create = Create.new(nil)
          
          Login.stub(:validate_player_name) { true }
          Login.stub(:validate_player_password) { true }
        end
        
        it "should fail if user/password isn't specified" do
          cmd = Command.new(@client, "create")
          @client.should_receive(:emit_failure).with("invalid_create_syntax")
          @create.on_command(@client, cmd)        
        end

        it "should fail if password isn't specified" do
          cmd = Command.new(@client, "create playername")
          @client.should_receive(:emit_failure).with("invalid_create_syntax")
          @create.on_command(@client, cmd)        
        end
        
        it "should accept a multi-word password" do
          cmd = Command.new(@client, "create playername bob's password")
          @create.should_receive(:create_player_and_login).with(@client, "playername", "bob's password")
          @create.on_command(@client, cmd)
        end    
        
        it "should make sure the name is valid" do
          cmd = Command.new(@client, "create playername password")
          Login.should_receive(:validate_player_name).with(@client, "playername") { false }
          @create.should_not_receive(:create_player_and_login)
          @create.on_command(@client, cmd)        
        end

        it "should make sure the password is valid" do
          cmd = Command.new(@client, "create playername password")
          Login.should_receive(:validate_player_password).with(@client, "password") { false }
          @create.should_not_receive(:create_player_and_login)
          @create.on_command(@client, cmd)        
        end
        
        it "should create the player" do
          cmd = Command.new(@client, "create playername password")
          @create.should_receive(:create_player_and_login).with(@client, "playername", "password")
          @create.on_command(@client, cmd)        
        end
        
            
      end
      
       describe :create_player do
          before do
            AresMUSH::Locale.stub(:translate).with("login.created_and_logged_in", { :name => "playername" }) { "created_and_logged_in" }
            @client = double(Client)
            @dispatcher = mock
            container = mock
            container.stub(:dispatcher) { @dispatcher }
            @create = Create.new(container)

            Player.stub(:create_player)
            @client.stub(:emit_success)
            @client.stub(:player=)
            @dispatcher.stub(:on_event)
          end

          it "should create the player" do          
            Player.should_receive(:create_player).with("playername", "password")
            @create.create_player_and_login(@client, "playername", "password")
          end

          it "should tell the player they're created" do
            @client.should_receive(:emit_success).with("created_and_logged_in")
            @create.create_player_and_login(@client, "playername", "password")
          end

          it "should set the player on the client" do
            player = mock
            Player.stub(:create_player).with("playername", "password") { player }
            @client.should_receive(:player=).with(player)
            @create.create_player_and_login(@client, "playername", "password")
          end

          it "should dispatch the created event" do
            @dispatcher.should_receive(:on_event) do |type, args|
              type.should eq :player_created
              args[:client].should eq @client
            end
            @create.create_player_and_login(@client, "playername", "password")
          end
        end
    end
  end
end

