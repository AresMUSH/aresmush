require_relative "../../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadCmd do
      include CommandTestHelper
  
      before do
        init_handler(LoadCmd, "load")
        handler.load_target = "foo"
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :validate do
        it "should incorporate the login check" do
          handler.methods.should include :validate_check_for_login
        end
        
        it "should incorporate the no switch check" do
          handler.methods.should include :validate_check_for_allowed_switches
          handler.allowed_switches.should eq []
        end
      end
      
      describe :validate_load_target do
        it "should reject command if no args specified" do
          handler.stub(:load_target) { nil }
          handler.validate_load_target.should eq 'manage.invalid_load_syntax'
        end
        
        it "should accept command otherwise" do
          client.stub(:logged_in?) { true }
          handler.validate_load_target.should eq nil
        end
      end
      
    end
  end
end