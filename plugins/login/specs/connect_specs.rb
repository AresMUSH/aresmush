require "plugin_test_loader"

module AresMUSH
  module Login  
    describe ConnectCmd do
      include GlobalTestHelper
      
      before do
        stub_translate_for_testing  
        stub_global_objects      
        @found_char = double
        @client = double
        allow(@client).to receive(:ip_addr) { "ip" }
        allow(@client).to receive(:hostname) { "host" }
        allow(@found_char).to receive(:login_failures) { 0 }
        allow(@found_char).to receive(:is_statue?) { false }
        allow(@found_char).to receive(:name) { "" }
        allow(@found_char).to receive(:handle) { nil }
        allow(@client).to receive(:logged_in?) { false }
        allow(Login).to receive(:is_banned?) { false }
        @handler = ConnectCmd.new(@client, Command.new("connect Bob password"), nil)
      end
      
      describe :crack do
        it "should crack the arguments" do
          @handler.parse_args
          expect(@handler.charname).to eq "Bob"
          expect(@handler.password).to eq "password"
        end
        
        it "should handle no args" do
          @handler = ConnectCmd.new(@client, Command.new("connect"), nil)
          @handler.parse_args
          expect(@handler.charname).to be_nil
          expect(@handler.password).to be_nil
        end
        
        it "should handle a missing password" do
          @handler = ConnectCmd.new(@client, Command.new("connect Bob"), nil)
          @handler.parse_args
          expect(@handler.charname).to eq "Bob"
          expect(@handler.password).to eq ""
        end

        it "should accept a multi-word password" do
          @handler = ConnectCmd.new(@client, Command.new("connect Bob bob's password"), nil)
          @handler.parse_args
          expect(@handler.charname).to eq "Bob"
          expect(@handler.password).to eq "bob's password"
        end
      end  
     
      describe :check_not_already_logged_in do
        it "should reject command if already logged in" do
          allow(@client).to receive(:logged_in?) { true }
          expect(@handler.check_not_already_logged_in).to eq "login.already_logged_in"
        end
       
        it "should accept command if not already logged in" do
          allow(@client).to receive(:logged_in?) { false }
          expect(@handler.check_not_already_logged_in).to eq nil
        end
      end
     
      describe :handle do  
        before do
          allow(Login).to receive(:terms_of_service) { nil }
          allow(@client).to receive(:program) { {} }       
          allow(Login).to receive(:can_login?) { true }
          allow(@found_char).to receive(:boot_timeout) { nil }
          @handler.parse_args
        end
             
        context "failure" do
          it "should fail if char not found" do
            expect(Character).to receive(:find_any_by_name).with("Bob") { [ ] }
            expect(Global).to_not receive(:queue_event)
            expect(@client).to receive(:emit_failure).with("db.object_not_found")
            @handler.handle
          end
                      
          it "should fail if check login fails" do
            expect(Character).to receive(:find_any_by_name).with("Bob") { [ @found_char ] }
            fail_status = { status: 'error', error: 'error' }
            expect(Login).to receive(:check_login).with(@found_char, "password", "ip", "host") { fail_status }
            expect(Global).to_not receive(:queue_event)
            expect(@client).to receive(:emit_failure).with("error")
            @handler.handle
          end
                      
        end
     
        context "success" do
          before do
            allow(Login).to receive(:find_game_client).with(@found_char) { nil }
            allow(@found_char).to receive(:id) { 3 }
            expect(Character).to receive(:find_any_by_name) { [ @found_char ] }
            allow(dispatcher).to receive(:queue_event)  
            allow(@client).to receive(:char_id=)    
            allow(@found_char).to receive(:update)
            ok_status = { status: 'ok' }  
            allow(Login).to receive(:check_login) { ok_status }
          end
          
          it "should disconnect an existing client" do
            other_client = double
            allow(Login).to receive(:find_game_client).with(@found_char) { other_client }
            expect(other_client).to receive(:emit_ooc).with('login.disconnected_by_reconnect')
            expect(other_client).to receive(:disconnect)
            allow(dispatcher).to receive(:queue_timer)
            @handler.handle            
          end
          
          it "should check login details" do
            ok_status = { status: 'ok' }  
            expect(Login).to receive(:check_login).with(@found_char, "password", "ip", "host") { ok_status }
            @handler.handle
          end        
       
          it "should reset login failures and boot timeout" do
            expect(@found_char).to receive(:update).with({login_failures: 0})
            expect(@found_char).to receive(:update).with({boot_timeout: nil})
            @handler.handle
          end
                        
          it "should set the char on the client" do
            expect(@client).to receive(:char_id=).with(3)
            @handler.handle
          end
          
          it "should announce the char connected event" do
            expect(dispatcher).to receive(:queue_event) do |event|
              expect(event.class).to eq CharConnectedEvent
              expect(event.client).to eq @client
            end
            @handler.handle
          end
        
          it "should prompt with the terms of service if defined and not acknowledged" do
            allow(Login).to receive(:terms_of_service) { "tos text" }
            allow(@found_char).to receive(:terms_of_service_acknowledged) { nil }
            expect(@client).to receive(:emit).with("%lh\ntos text%rlogin.tos_agree\n%lf")
            expect(@client).to_not receive(:char_id=)
            @handler.handle
          end
          
          it "should not prompt for TOS if already acknowledged" do
            allow(Login).to receive(:terms_of_service) { "tos text" }
            allow(@found_char).to receive(:terms_of_service_acknowledged) { DateTime.now }
            expect(@client).to receive(:char_id=).with(3)
            @handler.handle
          end
        end      
      end
    end
  end
end
