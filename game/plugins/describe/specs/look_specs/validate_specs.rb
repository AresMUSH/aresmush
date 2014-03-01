require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe

    describe LookCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(DescCmd, "look name")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
    end     
  end
end