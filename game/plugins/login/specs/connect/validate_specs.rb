require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login  
    describe ConnectCmd do
      include CommandTestHelper
      
      before do
        init_handler(ConnectCmd, "connect Bob bobpassword")
        SpecHelpers.stub_translate_for_testing        
      end
      
      describe :validate_not_already_logged_in do
        it "should reject command if already logged in" do
          client.stub(:logged_in?) { true }
          handler.validate_not_already_logged_in.should eq "login.already_logged_in"
        end
        
        it "should accept command if not already logged in" do
          client.stub(:logged_in?) { false }
          handler.validate_not_already_logged_in.should eq nil
        end
      end
      
      describe :validate_name_and_password do
        it "should fail if no name provided" do
          handler.stub(:password) { "password" }
          handler.stub(:charname) { nil }
          handler.validate_name_and_password.should eq "login.invalid_connect_syntax"
        end

        it "should fail if no password provided" do
          handler.stub(:password) { nil }
          handler.stub(:charname) { "password" }
          handler.validate_name_and_password.should eq "login.invalid_connect_syntax"
        end
        
        it "should pass if arguments are valid" do
          handler.stub(:password) { "password" }
          handler.stub(:charname) { "name" }
          handler.validate_name_and_password.should be_nil          
        end  
      end      
    end          
  end
end