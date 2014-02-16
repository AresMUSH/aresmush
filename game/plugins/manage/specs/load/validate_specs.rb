require_relative "../../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadCmd do
      include CommandTestHelper
  
      before do
        init_handler(LoadCmd, "load foo")
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :validate do
        it "should reject command if not logged in" do
          client.stub(:logged_in?) { false }
          handler.validate.should eq 'dispatcher.must_be_logged_in'
        end
        
        it "should reject command if no args specified" do
          client.stub(:logged_in?) { true }
          cmd.stub(:args) { nil }
          handler.validate.should eq 'manage.invalid_load_syntax'
        end
        
        it "should reject command if a switch is specified" do
          client.stub(:logged_in?) { true }
          cmd.stub(:switch) { "sw" }
          handler.validate.should eq 'manage.invalid_load_syntax'
        end
        
        it "should accept command otherwise" do
          client.stub(:logged_in?) { true }
          handler.validate.should eq nil
        end
      end
    end
  end
end