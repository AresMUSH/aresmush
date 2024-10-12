require "plugin_test_loader"

module AresMUSH
  module Login
    describe CreateCmd do
      include GlobalTestHelper
      
      before do
        @client = double
        @handler = CreateCmd.new(@client, "create Bob bobpassword", nil)
        stub_translate_for_testing    
        stub_global_objects    
      end
      
      describe :check_not_already_logged_in do
        it "should reject command if already logged in" do
          allow(@client).to receive(:logged_in?) { true }
          expect(@handler.check_not_already_logged_in ).to eq "login.already_logged_in"
        end

        it "should allow command if not logged in" do
          allow(@client).to receive(:logged_in?) { false }
          expect(@handler.check_not_already_logged_in ).to be_nil
        end
      end
      
      describe :check_name do
        it "should fail if the name is missing" do
          allow(@handler).to receive(:charname) { nil }
          expect(@handler.check_name).to eq "dispatcher.invalid_syntax"
        end

        it "should fail if the name is invalid" do
          allow(@handler).to receive(:charname) { "Bob" }
          expect(Character).to receive(:check_name).with("Bob") { "invalid name"}
          expect(@handler.check_name).to eq "invalid name"          
        end
          
        it "should allow the comand if the name is ok" do
          allow(@handler).to receive(:charname) { "Bob" }
          expect(Character).to receive(:check_name) { nil }
          expect(@handler.check_name).to be_nil
        end
      end
        
      describe :check_password do
        it "should fail if the password is missing" do
          allow(@handler).to receive(:password) { nil }
          expect(@handler.check_password).to eq "dispatcher.invalid_syntax"
        end

        it "should fail if the password is invalid" do
          allow(@handler).to receive(:password) { "passwd" }
          expect(Character).to receive(:check_password).with("passwd") { "invalid password"}
          expect(@handler.check_password).to eq "invalid password"          
        end
          
        it "should allow the comand if the password is ok" do
          allow(@handler).to receive(:password) { "passwd" }
          expect(Character).to receive(:check_password) { nil }
          expect(@handler.check_password).to be_nil
        end
      end
      
      describe :handle do
        
        before do
          @handler.charname = "charname"
          @handler.password = "password"
          
          allow(dispatcher).to receive(:queue_event)

          allow(Login).to receive(:terms_of_service) { nil }
          
          @char = double.as_null_object
          allow(@char).to receive(:id) { 33 }
          allow(Character).to receive(:new) { @char }

          allow(@client).to receive(:emit_success)
          allow(@client).to receive(:char_id=) 
          allow(@client).to receive(:program) { {} }       
        
          game = double
          allow(Game).to receive(:master) { game }
          allow(game).to receive(:welcome_room) { double }
          stub_translate_for_testing        
        end
        
        it "should set the character's name" do          
          expect(@char).to receive(:name=).with("charname")
          @handler.handle
        end

        it "should set the character's password" do          
          expect(@char).to receive(:change_password).with("password")
          @handler.handle
        end

        it "should save the character" do          
          expect(@char).to receive(:save)
          @handler.handle
        end

        it "should tell the char they're created" do
          expect(@client).to receive(:emit_success).with("login.created_and_logged_in")
          @handler.handle
        end

        it "should set the char on the @client" do
          expect(@client).to receive(:char_id=).with(33)
          @handler.handle
        end

        it "should dispatch the created and connected event" do
          expect(dispatcher).to receive(:queue_event) do |event|
            expect(event.class).to eq CharCreatedEvent
            expect(event.client).to eq @client
          end
         
          expect(dispatcher).to receive(:queue_event) do |event|
            expect(event.class).to eq CharConnectedEvent
            expect(event.client).to eq @client
          end
          @handler.handle
        end
        
        it "should prompt with the terms of service if defined" do
          allow(Login).to receive(:terms_of_service) { "tos text" }
          expect(@client).to receive(:emit).with("%lh\ntos text%rlogin.tos_agree\n%lf")
          expect(@client).to_not receive(:char=)
          @handler.handle
        end
      end
    end
  end
end

