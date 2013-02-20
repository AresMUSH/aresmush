$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require "create"

module AresMUSH
  module Login
    describe Create do
      before do
        AresMUSH::Locale.stub(:translate).with("login.invalid_create_syntax") { "invalid_create_syntax" }
        AresMUSH::Locale.stub(:translate).with("login.player_name_taken") { "player_name_taken" }
        AresMUSH::Locale.stub(:translate).with("login.password_too_short") { "password_too_short" }
        AresMUSH::Locale.stub(:translate).with("login.player_created", { :name => "playername" }) { "player_created" }
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
      
      # SUCCESS
      describe :on_command do
        before do
          @dispatcher = double(Dispatcher).as_null_object
          container = double(Container)
          container.stub(:dispatcher) { @dispatcher }

          @client = double(Client).as_null_object
          @player = mock
          Player.stub(:find_by_name).with("playername") { [] }
          Player.stub(:create) { @player }
          
          @cmd = Command.new(@client, "create playername password")
          @create = Create.new(container)
        end
        
        it "should create the player with the provided name" do          
          Player.should_receive(:create) do |args|
            args["name"].should eq "playername"
          end
          @create.on_command(@client, @cmd)                  
        end
        
        it "should hash the password" do
          Player.should_receive(:hash_password).with("password") { "pwhash" }
          Player.should_receive(:create) do |args|
            args["password"].should eq "pwhash"
          end
          @create.on_command(@client, @cmd)                  
        end
        
        it "should tell the player they're created" do
          @client.should_receive(:emit_success).with("player_created")
          @create.on_command(@client, @cmd)                  
        end
        
        it "should set the player on the client" do
          @client.should_receive(:player=).with(@player)
          @create.on_command(@client, @cmd)                  
        end
        
        it "should dispatch the created event" do
          @dispatcher.should_receive(:on_event) do |type, args|
            type.should eq :player_created
            args[:client].should eq @client
          end
          @create.on_command(@client, @cmd)                  
        end
      end
      
      # FAILURE
      describe :on_command do
        before do
          @client = double(Client)
          @client.stub(:player) { }
          @create = Create.new(nil)
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
        
        it "should fail if password is too short" do
          cmd = Command.new(@client, "create playername bar")
          @client.should_receive(:emit_failure).with("password_too_short")
          @create.on_command(@client, cmd)        
        end
        
        it "should fail if the player already exists" do
          cmd = Command.new(@client, "create playername password")
          Player.stub(:find_by_name).with("playername") { [mock] }
          @client.should_receive(:emit_failure).with("player_name_taken")
          @create.on_command(@client, cmd)                  
        end
      end
    end
  end
end

