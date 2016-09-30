require_relative "../../plugin_test_loader"

module AresMUSH
  module Login  
    describe ConnectCmd do
      include CommandHandlerTestHelper
      include GlobalTestHelper
      
      before do
        init_handler(ConnectCmd, "connect Bob password")
        SpecHelpers.stub_translate_for_testing  
        stub_global_objects      
        client.stub(:logged_in?) { false }
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
          handler.charname.should eq "Bob"
          handler.password.should eq ""
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
            Global.should_not_receive(:queue_event)
            client.should_receive(:emit_failure).with("db.object_not_found")
            handler.handle
          end
                         
          it "should fail if the passwords don't match" do
            found_char = double
            found_char.should_receive(:compare_password).with("password") { false }
            Character.should_receive(:find_all_by_name_or_id).with("Bob") { [found_char] }
            client.should_receive(:emit_failure).with("login.password_incorrect")
            Global.should_not_receive(:queue_event)
            handler.handle
          end
        end
     
        context "success" do
          before do
            @found_char = double
            @found_char.stub(:client) { nil }
            @found_char.stub(:id) { 3 }
            Character.should_receive(:find_all_by_name_or_id) { [ @found_char ] }
            @found_char.stub(:compare_password).with("password") { true }  
         
            dispatcher.stub(:queue_event)  
            client.stub(:char_id=)      
          end
          
          it "should disconnect an existing client" do
            other_client = double
            @found_char.stub(:client) { other_client }
            other_client.should_receive(:emit_ooc).with('login.disconnected_by_reconnect')
            other_client.should_receive(:disconnect)
            dispatcher.stub(:queue_timer)
            handler.handle            
          end
          
          it "should compare passwords" do
            @found_char.should_receive(:compare_password).with("password")
            handler.handle
          end        
       
          it "should set the char on the client" do
            client.should_receive(:char_id=).with(3)
            handler.handle
          end

          it "should announce the char connected event" do
            dispatcher.should_receive(:queue_event) do |event|
              event.class.should eq CharConnectedEvent
              event.client.should eq client
            end
            handler.handle
          end
        end      
      end
    end
  end
end