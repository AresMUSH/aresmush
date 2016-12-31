require_relative "../../plugin_test_loader"

module AresMUSH
  module Login  
    describe ConnectCmd do
      include GlobalTestHelper
      
      before do
        SpecHelpers.stub_translate_for_testing  
        stub_global_objects      
        @found_char = double
        @client = double
        @client.stub(:ip_addr) { "" }
        @found_char.stub(:login_failures) { 0 }
        @client.stub(:logged_in?) { false }
        @handler = ConnectCmd.new(@client, Command.new("connect Bob password"), nil)
      end
      
      describe :crack do
        it "should crack the arguments" do
          @handler.crack!
          @handler.charname.should eq "Bob"
          @handler.password.should eq "password"
        end
        
        it "should handle no args" do
          @handler = ConnectCmd.new(@client, Command.new("connect"), nil)
          @handler.crack!
          @handler.charname.should be_nil
          @handler.password.should be_nil
        end
        
        it "should handle a missing password" do
          @handler = ConnectCmd.new(@client, Command.new("connect Bob"), nil)
          @handler.crack!
          @handler.charname.should eq "Bob"
          @handler.password.should eq ""
        end

        it "should accept a multi-word password" do
          @handler = ConnectCmd.new(@client, Command.new("connect Bob bob's password"), nil)
          @handler.crack!
          @handler.charname.should eq "Bob"
          @handler.password.should eq "bob's password"
        end
      end  
     
      describe :check_not_already_logged_in do
        it "should reject command if already logged in" do
          @client.stub(:logged_in?) { true }
          @handler.check_not_already_logged_in.should eq "login.already_logged_in"
        end
       
        it "should accept command if not already logged in" do
          @client.stub(:logged_in?) { false }
          @handler.check_not_already_logged_in.should eq nil
        end
      end
     
      describe :handle do  
        before do
          @handler.crack!
        end
             
        context "failure" do
          it "should fail if there isn't a matching char" do
            Character.should_receive(:find_any_by_name).with("Bob") { [] }
            Global.should_not_receive(:queue_event)
            @client.should_receive(:emit_failure).with("db.object_not_found")
            @handler.handle
          end
                         
          it "should fail if the passwords don't match" do
            @found_char.should_receive(:compare_password).with("password") { false }
            Character.should_receive(:find_any_by_name).with("Bob") { [@found_char] }
            @client.should_receive(:emit_failure).with("login.password_incorrect")
            @found_char.should_receive(:update).with(login_failures: 1)
            Global.should_not_receive(:queue_event)
            @handler.handle
          end
        end
     
        context "success" do
          before do
            @found_char.stub(:client) { nil }
            @found_char.stub(:id) { 3 }
            Character.should_receive(:find_any_by_name) { [ @found_char ] }
            @found_char.stub(:compare_password).with("password") { true }  
            @found_char.stub(:update) {}
            dispatcher.stub(:queue_event)  
            @client.stub(:char_id=)      
          end
          
          it "should disconnect an existing client" do
            other_client = double
            @found_char.stub(:client) { other_client }
            other_client.should_receive(:emit_ooc).with('login.disconnected_by_reconnect')
            other_client.should_receive(:disconnect)
            dispatcher.stub(:queue_timer)
            @handler.handle            
          end
          
          it "should compare passwords" do
            @found_char.should_receive(:compare_password).with("password")
            @handler.handle
          end        
       
          it "should set the char on the client" do
            @client.should_receive(:char_id=).with(3)
            @handler.handle
          end
          
          it "should reset login failures" do
            @found_char.should_receive(:update).with(login_failures: 0)
            @handler.handle
          end

          it "should announce the char connected event" do
            dispatcher.should_receive(:queue_event) do |event|
              event.class.should eq CharConnectedEvent
              event.client.should eq @client
            end
            @handler.handle
          end
        end      
      end
    end
  end
end