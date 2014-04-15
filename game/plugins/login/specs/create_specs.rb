require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
    describe CreateCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(CreateCmd, "create Bob bobpassword")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      
      describe :want_command? do
        it "should want the create command" do
          cmd.stub(:root_is?).with("create") { true }
          handler.want_command?(client, cmd).should eq true
        end

        it "should not want a different command" do
          cmd.stub(:root_is?).with("create") { false }
          handler.want_command?(client, cmd).should eq false
        end
      end
      
      describe :crack! do
        it "should be able to crack correct args" do
          init_handler(CreateCmd, "create Bob foo")
          handler.crack!
          handler.charname.should eq "Bob"
          handler.password.should eq "foo"
        end

        it "should be able to crack if args are missing" do
          init_handler(CreateCmd, "create")
          handler.crack!
          handler.charname.should be_nil
          handler.password.should be_nil
        end
        
        it "should be able to crack a multi-word password" do
          init_handler(CreateCmd, "create Bob bob's passwd")
          handler.crack!
          handler.charname.should eq "Bob"
          handler.password.should eq "bob's passwd"
        end
                
        it "should be able to crack a missing password" do
          init_handler(CreateCmd, "create Bob")
          handler.crack!
          handler.charname.should be_nil
          handler.password.should be_nil
        end
      end
      
      describe :check_not_already_logged_in do
        it "should reject command if already logged in" do
          client.stub(:logged_in?) { true }
          handler.check_not_already_logged_in .should eq "login.already_logged_in"
        end

        it "should allow command if not logged in" do
          client.stub(:logged_in?) { false }
          handler.check_not_already_logged_in .should be_nil
        end
      end
      
      describe :check_name do
        it "should fail if the name is missing" do
          handler.stub(:charname) { nil }
          handler.check_name.should eq "dispatcher.invalid_syntax"
        end

        it "should fail if the name is invalid" do
          handler.stub(:charname) { "Bob" }
          Character.should_receive(:check_name).with("Bob") { "invalid name"}
          handler.check_name.should eq "invalid name"          
        end
          
        it "should allow the comand if the name is ok" do
          handler.stub(:charname) { "Bob" }
          Character.should_receive(:check_name) { nil }
          handler.check_name.should be_nil
        end
      end
        
      describe :check_password do
        it "should fail if the password is missing" do
          handler.stub(:password) { nil }
          handler.check_password.should eq "dispatcher.invalid_syntax"
        end

        it "should fail if the password is invalid" do
          handler.stub(:password) { "passwd" }
          Character.should_receive(:check_password).with("passwd") { "invalid password"}
          handler.check_password.should eq "invalid password"          
        end
          
        it "should allow the comand if the password is ok" do
          handler.stub(:password) { "passwd" }
          Character.should_receive(:check_password) { nil }
          handler.check_password.should be_nil
        end
      end
      
      describe :handle do
        
        before do
          init_handler(CreateCmd, "create charname password")
          handler.crack!

          @dispatcher = double.as_null_object
          Global.stub(:dispatcher) { @dispatcher }
          @dispatcher.stub(:on_event)

          Global.stub(:config) { { "connect" => {} } }
          
          @char = double.as_null_object
          Character.stub(:new) { @char }

          client.stub(:emit_success)
          client.stub(:char=) 
          client.stub(:reset_program)       
        
          SpecHelpers.stub_translate_for_testing        
        end
        
        it "should set the character's name" do          
          @char.should_receive(:name=).with("charname")
          handler.handle
        end

        it "should set the character's password" do          
          @char.should_receive(:change_password).with("password")
          handler.handle
        end

        it "should save the character" do          
          @char.should_receive(:save!)
          handler.handle
        end

        it "should tell the char they're created" do
          client.should_receive(:emit_success).with("login.created_and_logged_in")
          handler.handle
        end

        it "should set the char on the client" do
          client.should_receive(:char=).with(@char)
          handler.handle
        end

        it "should dispatch the created and connected event" do
          @dispatcher.should_receive(:on_event) do |type, args|
            type.should eq :char_created
            args[:client].should eq client
          end
         
          @dispatcher.should_receive(:on_event) do |type, args|
            type.should eq :char_connected
            args[:client].should eq client
          end
          handler.handle
        end
        
        it "should prompt with the terms of service if defined" do
          Global.stub(:config) { { "connect" => { "terms_of_service" => "tos.txt" }}}
          File.stub(:read).with("tos.txt") { "tos text" }
          client.stub(:program) { {} }
          client.should_receive(:emit).with("tos text")
          client.should_receive(:program=).with( { :create_cmd => cmd })
          client.should_not_receive(:char=)
          handler.handle
        end
      end
    end
  end
end

