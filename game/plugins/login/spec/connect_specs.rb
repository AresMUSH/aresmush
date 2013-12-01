require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
  
    describe Connect do
      before do
        @connect = Connect.new
        @client = double(Client)
        SpecHelpers.stub_translate_for_testing
      end
      

      describe :want_command? do
        it "wants the connect command" do
          cmd = double
          cmd.stub(:root_is?).with("connect") { true }
          @connect.want_command?(cmd).should be_true
        end

        it "doesn't want another command" do
          cmd = double
          cmd.stub(:root_is?).with("connect") { false }
          @connect.want_command?(cmd).should be_false
        end
      end
      
      # FAILURE
      describe :on_command do
        
        it "should fail if there's no password" do
          cmd = Command.new(@client, "connect Bob")
          @client.should_receive(:emit_failure).with("login.invalid_connect_syntax")
          Global.should_not_receive(:on_event)
          @connect.on_command(@client, cmd)          
        end

        it "should fail if there's no name and password" do
          cmd = Command.new(@client, "connect")
          @client.should_receive(:emit_failure).with("login.invalid_connect_syntax")
          Global.should_not_receive(:on_event)
          @connect.on_command(@client, cmd)          
        end

        it "should fail if there isn't a single matching char" do
          cmd = Command.new(@client, "connect Bob password")
          find_result = FindResult.new(nil, "Not found")
          SingleTargetFinder.should_receive(:find).with("Bob", Character) { find_result }
          Global.should_not_receive(:on_event)
          @client.should_receive(:emit_failure).with("Not found")
          @connect.on_command(@client, cmd)          
        end
                          
        it "should fail if the passwords don't match" do
          cmd = Command.new(@client, "connect Bob password")
          found_char = double
          find_result = FindResult.new(found_char, "Not found")
          SingleTargetFinder.stub(:find) { find_result }
          Character.stub(:compare_password).with(found_char, "password") { false }
          @client.should_receive(:emit_failure).with("login.invalid_password")
          Global.should_not_receive(:on_event)
          @connect.on_command(@client, cmd)          
        end        
      end
      
      # SUCCESS
      describe :on_command do
        before do
          @found_char = double
          @dispatcher = double(Dispatcher)
          Global.stub(:dispatcher) { @dispatcher }
          
          find_result = FindResult.new(@found_char, nil)
          SingleTargetFinder.stub(:find) { find_result }
          
          Character.stub(:compare_password).with(@found_char, "password") { true }  
          @dispatcher.stub(:on_event)  
          @client.stub(:char=)      
        end
        
        it "should compare passwords" do
          cmd = Command.new(@client, "connect Bob password")
          Character.should_receive(:compare_password).with(@found_char, "password")
          @connect.on_command(@client, cmd)          
        end
        
        it "should accept a multi-word password" do
          cmd = Command.new(@client, "connect Bob bob's password")
          Character.should_receive(:compare_password).with(@found_char, "bob's password") { true }
          @connect.on_command(@client, cmd)          
        end
        
        it "should set the char on the client" do
          cmd = Command.new(@client, "connect Bob password")
          @client.should_receive(:char=).with(@found_char)
          @connect.on_command(@client, cmd)
        end

        it "should announce the char connected event" do
           cmd = Command.new(@client, "connect Bob password")
           @dispatcher.should_receive(:on_event) do |type, args|
             type.should eq :char_connected
             args[:client].should eq @client
           end
           @connect.on_command(@client, cmd)
        end
      end      
    end
  end
end