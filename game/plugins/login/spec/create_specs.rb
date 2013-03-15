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
          @client.stub(:player) { }
          @dispatcher = mock
          container = mock
          container.stub(:dispatcher) { @dispatcher }
          @create = Create.new(container)
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
        
        it "should try to create the player" do
          cmd = Command.new(@client, "create playername bar")
          Login.should_receive(:create_player).with(@client, "playername", "bar", @dispatcher)
          @create.on_command(@client, cmd)        
        end
        
        it "should accept a multi-word password" do
          cmd = Command.new(@client, "create playername bob's password")
          Login.should_receive(:create_player).with(@client, "playername", "bob's password", @dispatcher)
          Login.create_player(@client, "playername", "bob's password", @dispatcher)
        end
        
      end
    end
  end
end

