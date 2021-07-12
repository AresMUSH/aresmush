require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe UnloadPluginCmd do
      include GlobalTestHelper
  
      before do
        @client = double
        @handler = UnloadPluginCmd.new(@client, nil, nil)
        stub_translate_for_testing
        stub_global_objects
      end
      
      describe :handle do
        
        before do
          @handler.load_target = "foo"
            
          allow(@client).to receive(:emit_success)
          allow(plugin_manager).to receive(:unload_plugin)
          allow(Help).to receive(:reload_help)
          allow(locale).to receive(:reload)
          allow(config_reader).to receive(:load_game_config)
        end
          
        it "should unload the plugin" do
          expect(plugin_manager).to receive(:unload_plugin).with("foo")
          @handler.handle
        end
        
        it "should reload the help, locale, and config" do
          expect(config_reader).to receive(:load_game_config)
          expect(Help).to receive(:reload_help)
          expect(locale).to receive(:reload)
          @handler.handle
        end
          
        it "should notify the client" do
          expect(@client).to receive(:emit_success).with('manage.plugin_unloaded')
          @handler.handle
        end

        it "should notify client if plugin not found" do
          allow(plugin_manager).to receive(:unload_plugin) { raise SystemNotFoundException }
          expect(@client).to receive(:emit_failure).with('manage.plugin_not_found')
          @handler.handle
        end
          
        it "should notify client if plugin unload has an error" do
          allow(plugin_manager).to receive(:unload_plugin) { raise "Error" }
          expect(@client).to receive(:emit_failure).with('manage.error_unloading_plugin')
          @handler.handle
        end
      end
    end
  end
end
