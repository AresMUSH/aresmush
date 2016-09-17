require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadLocaleCmd do
      include CommandHandlerTestHelper
      include GlobalTestHelper
  
      before do
        init_handler(LoadLocaleCmd, "load locale")
        SpecHelpers.stub_translate_for_testing
        stub_global_objects
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :handle do        
        it "should reload the locale and notify client" do
          plugin = double
          plugin_manager.stub(:plugins) { [plugin] }

          locale.should_receive(:reset_load_path)
          plugin_manager.should_receive(:load_plugin_locale).with( plugin ) {}
          locale.should_receive(:reload)
          client.should_receive(:emit_success).with('manage.locale_loaded')
          handler.handle
        end
        
        it "should handle errors from locale load" do
          locale.should_receive(:reset_load_path) { raise "Error" }
          client.should_receive(:emit_failure).with('manage.error_loading_locale')
          handler.handle
        end     
      end
    end
  end
end