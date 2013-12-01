require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
  
    describe Connect do
      before do
        @connect = Connect.new
        @client = double(Client)
        @connect.client = @client
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
      
      describe :crack do
        it "should crack the arguments" do
          cmd = Command.new(@client, "connect Bob password")
          @connect.cmd = cmd
          @connect.crack!
          @connect.args.name.should eq "Bob"
          @connect.args.password.should eq "password"
        end
        
        it "should handle no args" do
          cmd = Command.new(@client, "connect")
          @connect.cmd = cmd
          @connect.crack!
          @connect.args.name.should be_nil
          @connect.args.password.should be_nil
        end
        
        it "should handle a missing password" do
          cmd = Command.new(@client, "connect Bob")
          @connect.cmd = cmd
          @connect.crack!
          @connect.args.name.should be_nil
          @connect.args.password.should be_nil
        end

        it "should accept a multi-word password" do
          cmd = Command.new(@client, "connect Bob bob's password")
          @connect.cmd = cmd
          @connect.crack!
          @connect.args.name.should eq "Bob"
          @connect.args.password.should eq "bob's password"
        end        
      end
      
      
      describe :validate do
        before do
          @cmd = double
          @cmd.stub(:logged_in?) { false }
          @connect.cmd = @cmd
        end
        
        it "should fail if already logged in" do
          @cmd.stub(:logged_in?) { true }
          @connect.validate.should eq "login.already_logged_in"
        end
        
        it "should fail if no name provided" do
          @connect.stub(:args) { HashReader.new( { "name" => nil, "password" => "foo" })}
          @connect.validate.should eq "login.invalid_connect_syntax"
        end

        it "should fail if no password provided" do
          @connect.stub(:args) { HashReader.new( { "name" => "Bob", "password" => nil })}
          @connect.validate.should eq "login.invalid_connect_syntax"
        end
        
        it "should pass if arguments are valid" do
          @connect.stub(:args) { HashReader.new( { "name" => "Bob", "password" => "foo" })}
          @connect.validate.should be_nil          
        end        
      end
      
      # FAILURE
      describe :handle do
        before do
          @connect.stub(:args) { HashReader.new( { "name" => "Bob", "password" => "password" } )}
        end

        it "should fail if there isn't a single matching char" do
          find_result = FindResult.new(nil, "Not found")
          SingleTargetFinder.should_receive(:find).with("Bob", Character) { find_result }
          Global.should_not_receive(:on_event)
          @client.should_receive(:emit_failure).with("Not found")
          @connect.handle
        end
                          
        it "should fail if the passwords don't match" do
          found_char = double
          SingleTargetFinder.stub(:find) { FindResult.new(found_char, nil) }
          Character.stub(:compare_password).with(found_char, "password") { false }
          @client.should_receive(:emit_failure).with("login.invalid_password")
          Global.should_not_receive(:on_event)
          @connect.handle
        end        
      end
      
      # SUCCESS
      describe :handle do
        before do
          @found_char = double
          @dispatcher = double(Dispatcher)
          Global.stub(:dispatcher) { @dispatcher }
          
          find_result = FindResult.new(@found_char, nil)
          SingleTargetFinder.stub(:find) { find_result }
          
          Character.stub(:compare_password).with(@found_char, "password") { true }  
          @connect.stub(:args) { HashReader.new( { "name" => "Bob", "password" => "password" } )}
          
          @dispatcher.stub(:on_event)  
          @client.stub(:char=)      
        end
        
        it "should compare passwords" do
          Character.should_receive(:compare_password).with(@found_char, "password")
          @connect.handle
        end        
        
        it "should set the char on the client" do
          @client.should_receive(:char=).with(@found_char)
          @connect.handle
        end

        it "should announce the char connected event" do
           @dispatcher.should_receive(:on_event) do |type, args|
             type.should eq :char_connected
             args[:client].should eq @client
           end
           @connect.handle
        end
      end      
    end
  end
end