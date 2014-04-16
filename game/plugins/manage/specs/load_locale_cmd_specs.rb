require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadLocaleCmd do
      include PluginCmdTestHelper
      include GlobalTestHelper
  
      before do
        init_handler(LoadLocaleCmd, "load locale")
        SpecHelpers.stub_translate_for_testing
        stub_global_objects
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :handle do        
        it "should reload the locale and notify client" do
          locale.should_receive(:load!)
          client.should_receive(:emit_success).with('manage.locale_loaded')
          handler.handle
        end
        
        it "should handle errors from config load" do
          locale.should_receive(:load!) { raise "Error" }
          client.should_receive(:emit_failure).with('manage.error_loading_locale')
          handler.handle
        end     
      end
    end
  end
end