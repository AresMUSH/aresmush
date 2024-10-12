require "plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadLocaleCmd do
      include GlobalTestHelper
  
      before do
        @client = double
        @handler = LoadLocaleCmd.new(@client, nil, nil)
        stub_translate_for_testing
        stub_global_objects
      end
            
      describe :handle do        
        it "should reload the locale and notify client" do
          plugin = double
          allow(plugin_manager).to receive(:plugins) { [plugin] }

          expect(locale).to receive(:reset_load_path)
          expect(plugin_manager).to receive(:load_plugin_locale).with( plugin ) {}
          expect(locale).to receive(:reload)
          expect(@client).to receive(:emit_success).with('manage.locale_loaded')
          @handler.handle
        end
        
        it "should handle errors from locale load" do
          expect(locale).to receive(:reset_load_path) { raise "Error" }
          expect(@client).to receive(:emit_failure).with('manage.error_loading_locale')
          @handler.handle
        end     
      end
    end
  end
end
