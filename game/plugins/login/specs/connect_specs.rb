require_relative "../../plugin_test_loader"

module AresMUSH
  module Login  
    describe ConnectCmd do
      include PluginCmdTestHelper
      include GlobalTestHelper
      
      before do
        init_handler(ConnectCmd, "connect Bob password")
        SpecHelpers.stub_translate_for_testing  
        stub_global_objects      
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
            
      describe :want_command? do
        it "wants the connect command" do
          cmd.stub(:root_is?).with("connect") { true }
          handler.want_command?(client, cmd).should be_true
        end

        it "doesn't want another command" do
          cmd.stub(:root_is?).with("connect") { false }
          handler.want_command?(client, cmd).should be_false
        end
      end
      
      describe :crack do
        it "should crack the arguments" do
          init_handler(ConnectCmd, "connect Bob password")
          handler.crack!
          handler.charname.should eq "Bob"
          handler.password.should eq "password"
        end
        
        it "should handle no args" do
          init_handler(ConnectCmd, "connect")
          handler.crack!
          handler.charname.should be_nil
          handler.password.should be_nil
        end
        
        it "should handle a missing password" do
          init_handler(ConnectCmd, "connect Bob")
          handler.crack!
          handler.charname.should be_nil
          handler.password.should be_nil
        end

        it "should accept a multi-word password" do
          init_handler(ConnectCmd, "connect Bob bob's password")
          handler.crack!
          handler.charname.should eq "Bob"
          handler.password.should eq "bob's password"
        end
      end  
     
      describe :check_not_already_logged_in do
        it "should reject command if already logged in" do
          client.stub(:logged_in?) { true }
          handler.check_not_already_logged_in.should eq "login.already_logged_in"
        end
       
        it "should accept command if not already logged in" do
          client.stub(:logged_in?) { false }
          handler.check_not_already_logged_in.should eq nil
        end
      end
     
      describe :handle do  
        before do
          handler.crack!
        end
             
        context "failure" do
          it "should fail if there isn't a matching char" do
            Character.should_receive(:find_all_by_name_or_id).with("Bob") { [] }
            Global.should_not_receive(:on_event)
            client.should_receive(:emit_failure).with("db.object_not_found")
            handler.handle
          end
                         
          it "should fail if the passwords don't match" do
            found_char = double
            found_char.should_receive(:compare_password).with("password") { false }
            Character.should_receive(:find_all_by_name_or_id).with("Bob") { [found_char] }
            client.should_receive(:emit_failure).with("login.password_incorrect")
            Global.should_not_receive(:on_event)
            handler.handle
          end
        end
     
        context "success" do
          before do
            @found_char = double
            client_monitor.stub(:find_client) { nil }
            Character.should_receive(:find_all_by_name_or_id) { [ @found_char ] }
            @found_char.stub(:compare_password).with("password") { true }  
         
            dispatcher.stub(:on_event)  
            client.stub(:char=)      
          end
          
          it "should disconnect an existing client" do
            other_client = double
            client_monitor.stub(:find_client).with(@found_char) { other_client }
            other_client.should_receive(:disconnect)
            EM.stub(:add_timer)
            handler.handle            
          end
          
          it "should compare passwords" do
            @found_char.should_receive(:compare_password).with("password")
            handler.handle
          end        
       
          it "should set the char on the client" do
            client.should_receive(:char=).with(@found_char)
            handler.handle
          end

          it "should announce the char connected event" do
            dispatcher.should_receive(:on_event) do |type, args|
              type.should eq :char_connected
              args[:client].should eq client
            end
            handler.handle
          end
        end      
      end
    end
  end
end