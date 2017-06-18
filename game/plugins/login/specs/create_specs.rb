require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
    describe CreateCmd do
      include GlobalTestHelper
      
      before do
        @client = double
        @handler = CreateCmd.new(@client, "create Bob bobpassword", nil)
        SpecHelpers.stub_translate_for_testing    
        stub_global_objects    
      end
      
      describe :check_not_already_logged_in do
        it "should reject command if already logged in" do
          @client.stub(:logged_in?) { true }
          @handler.check_not_already_logged_in .should eq "login.already_logged_in"
        end

        it "should allow command if not logged in" do
          @client.stub(:logged_in?) { false }
          @handler.check_not_already_logged_in .should be_nil
        end
      end
      
      describe :check_name do
        it "should fail if the name is missing" do
          @handler.stub(:charname) { nil }
          @handler.check_name.should eq "dispatcher.invalid_syntax"
        end

        it "should fail if the name is invalid" do
          @handler.stub(:charname) { "Bob" }
          Character.should_receive(:check_name).with("Bob") { "invalid name"}
          @handler.check_name.should eq "invalid name"          
        end
          
        it "should allow the comand if the name is ok" do
          @handler.stub(:charname) { "Bob" }
          Character.should_receive(:check_name) { nil }
          @handler.check_name.should be_nil
        end
      end
        
      describe :check_password do
        it "should fail if the password is missing" do
          @handler.stub(:password) { nil }
          @handler.check_password.should eq "dispatcher.invalid_syntax"
        end

        it "should fail if the password is invalid" do
          @handler.stub(:password) { "passwd" }
          Character.should_receive(:check_password).with("passwd") { "invalid password"}
          @handler.check_password.should eq "invalid password"          
        end
          
        it "should allow the comand if the password is ok" do
          @handler.stub(:password) { "passwd" }
          Character.should_receive(:check_password) { nil }
          @handler.check_password.should be_nil
        end
      end
      
      describe :handle do
        
        before do
          @handler.charname = "charname"
          @handler.password = "password"
          
          dispatcher.stub(:queue_event)

          Login.stub(:terms_of_service) { nil }
          
          @char = double.as_null_object
          @char.stub(:id) { 33 }
          Character.stub(:new) { @char }

          @client.stub(:emit_success)
          @client.stub(:char_id=) 
          @client.stub(:program) { {} }       
        
          game = double
          Game.stub(:master) { game }
          game.stub(:welcome_room) { double }
          SpecHelpers.stub_translate_for_testing        
        end
        
        it "should set the character's name" do          
          @char.should_receive(:name=).with("charname")
          @handler.handle
        end

        it "should set the character's password" do          
          @char.should_receive(:change_password).with("password")
          @handler.handle
        end

        it "should save the character" do          
          @char.should_receive(:save)
          @handler.handle
        end

        it "should tell the char they're created" do
          @client.should_receive(:emit_success).with("login.created_and_logged_in")
          @handler.handle
        end

        it "should set the char on the @client" do
          @client.should_receive(:char_id=).with(33)
          @handler.handle
        end

        it "should dispatch the created and connected event" do
          dispatcher.should_receive(:queue_event) do |event|
            event.class.should eq CharCreatedEvent
            event.client.should eq @client
          end
         
          dispatcher.should_receive(:queue_event) do |event|
            event.class.should eq CharConnectedEvent
            event.client.should eq @client
          end
          @handler.handle
        end
        
        it "should prompt with the terms of service if defined" do
          Login.stub(:terms_of_service) { "tos text" }
          @client.should_receive(:emit).with("%lh%rtos text%rlogin.tos_agree%r%lf")
          @client.should_not_receive(:char=)
          @handler.handle
        end
      end
    end
  end
end

