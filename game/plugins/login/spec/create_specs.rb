require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
    describe Create do
      before do
        AresMUSH::Locale.stub(:translate).with("login.invalid_create_syntax") { "invalid_create_syntax" }
      end
      
      describe :want_command? do
        it "should want the create command if not logged in" do
          cmd = double(Command)
          cmd.stub(:root_is?).with("create") { true }
          cmd.stub(:logged_in?) { false }
          create = Create.new
          create.want_command?(cmd).should eq true
        end
        
        it "should not want the create command if logged in" do
          cmd = double(Command)
          cmd.stub(:root_is?).with("create") { true }
          cmd.stub(:logged_in?) { true }
          create = Create.new
          create.want_command?(cmd).should eq false
        end

        it "should not want a different command" do
          cmd = double(Command)
          cmd.stub(:root_is?).with("create") { false }
          cmd.stub(:logged_in?) { false }
          create = Create.new
          create.want_command?(cmd).should eq false
        end
      end
      
      describe :on_command do
        before do
          @client = double(Client)
          @create = Create.new
          
          Login.stub(:validate_char_name) { true }
          Login.stub(:validate_char_password) { true }
        end
        
        it "should fail if user/password isn't specified" do
          cmd = Command.new(@client, "create")
          @client.should_receive(:emit_failure).with("invalid_create_syntax")
          @create.on_command(@client, cmd)        
        end

        it "should fail if password isn't specified" do
          cmd = Command.new(@client, "create charname")
          @client.should_receive(:emit_failure).with("invalid_create_syntax")
          @create.on_command(@client, cmd)        
        end
        
        it "should accept a multi-word password" do
          cmd = Command.new(@client, "create charname bob's password")
          @create.should_receive(:create_char_and_login).with(@client, "charname", "bob's password")
          @create.on_command(@client, cmd)
        end    
        
        it "should make sure the name is valid" do
          cmd = Command.new(@client, "create charname password")
          Login.should_receive(:validate_char_name).with(@client, "charname") { false }
          @create.should_not_receive(:create_char_and_login)
          @create.on_command(@client, cmd)        
        end

        it "should make sure the password is valid" do
          cmd = Command.new(@client, "create charname password")
          Login.should_receive(:validate_char_password).with(@client, "password") { false }
          @create.should_not_receive(:create_char_and_login)
          @create.on_command(@client, cmd)        
        end
        
        it "should create the char" do
          cmd = Command.new(@client, "create charname password")
          @create.should_receive(:create_char_and_login).with(@client, "charname", "password")
          @create.on_command(@client, cmd)        
        end
        
            
      end
      
       describe :create_char do
          before do
            AresMUSH::Locale.stub(:translate).with("login.created_and_logged_in", { :name => "charname" }) { "created_and_logged_in" }
            @client = double(Client)
            @dispatcher = double
            Global.stub(:dispatcher) { @dispatcher }
            @create = Create.new

            Character.stub(:create_char)
            @client.stub(:emit_success)
            @client.stub(:char=)
            @dispatcher.stub(:on_event)
          end

          it "should create the char" do          
            Character.should_receive(:create_char).with("charname", "password")
            @create.create_char_and_login(@client, "charname", "password")
          end

          it "should tell the char they're created" do
            @client.should_receive(:emit_success).with("created_and_logged_in")
            @create.create_char_and_login(@client, "charname", "password")
          end

          it "should set the char on the client" do
            char = double
            Character.stub(:create_char).with("charname", "password") { char }
            @client.should_receive(:char=).with(char)
            @create.create_char_and_login(@client, "charname", "password")
          end

          it "should dispatch the created event" do
            @dispatcher.should_receive(:on_event) do |type, args|
              type.should eq :char_created
              args[:client].should eq @client
            end
            @create.create_char_and_login(@client, "charname", "password")
          end
        end
    end
  end
end

