require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
    describe LookCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(LookCmd, "look something")
        SpecHelpers.stub_translate_for_testing        
      end        

      describe :want_command? do
        it "wants the look command" do
          cmd.stub(:root_is?).with("look") { true }
          handler.want_command?(client, cmd).should be_true
        end
        
        it "doesn't want another command" do
          cmd.stub(:root_is?).with("look") { false }
          handler.want_command?(client, cmd).should be_false
        end
      end
      
    end
  end
end