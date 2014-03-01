require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
    describe CreateCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(CreateCmd, "create Bob bobpassword")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      
      describe :validate_not_already_logged_in do
        it "should reject command if already logged in" do
          client.stub(:logged_in?) { true }
          handler.validate_not_already_logged_in .should eq "login.already_logged_in"
        end

        it "should allow command if not logged in" do
          client.stub(:logged_in?) { false }
          handler.validate_not_already_logged_in .should be_nil
        end
      end
      
      describe :validate_name do
        
        it "should fail if the name is missing" do
          handler.stub(:charname) { nil }
          handler.validate_name.should eq "login.invalid_create_syntax"
        end

        it "should fail if the name is invalid" do
          handler.stub(:charname) { "Bob" }
          Login.should_receive(:validate_char_name).with("Bob") { "invalid name"}
          handler.validate_name.should eq "invalid name"          
        end
          
        it "should allow the comand if the name is ok" do
          handler.stub(:charname) { "Bob" }
          Login.should_receive(:validate_char_name) { nil }
          handler.validate_name.should be_nil
        end
      end
        
      describe :validate_password do
        it "should fail if the password is missing" do
          handler.stub(:password) { nil }
          handler.validate_password.should eq "login.invalid_create_syntax"
        end

        it "should fail if the password is invalid" do
          handler.stub(:password) { "passwd" }
          Login.should_receive(:validate_char_password).with("passwd") { "invalid password"}
          handler.validate_password.should eq "invalid password"          
        end
          
        it "should allow the comand if the name is ok" do
          handler.stub(:password) { "passwd" }
          Login.should_receive(:validate_char_password) { nil }
          handler.validate_password.should be_nil
        end
      end
    end
  end
end
