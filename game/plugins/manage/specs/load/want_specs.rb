require_relative "../../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadCmd do
      include CommandTestHelper
  
      before do
        init_handler(LoadCmd, "load foo")
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :want_command do
        it "should want the load command" do
          handler.want_command?(client, cmd).should be_true
        end
        
        it "should not want another command" do
          cmd.stub(:root_is?).with("load") { false }
          handler.want_command?(client, cmd).should be_false
        end
      end
    end
  end
end