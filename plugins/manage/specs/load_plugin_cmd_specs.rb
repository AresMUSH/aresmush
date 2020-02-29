require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadPluginCmd do
      include GlobalTestHelper
  
      before do
        @client = double
        @handler = LoadPluginCmd.new(@client, nil, nil)
        stub_translate_for_testing
        stub_global_objects
      end
      
      describe :handle do
        
        before do
          @handler.load_target = "foo"
            
          allow(@client).to receive(:emit_success)
          allow(@client).to receive(:emit_ooc)
          allow(plugin_manager).to receive(:load_plugin)
          allow(plugin_manager).to receive(:unload_plugin)
          allow(config_reader).to receive(:validate_game_config)
          allow(config_reader).to receive(:load_game_config)
          allow(Help).to receive(:reload_help)
          allow(locale).to receive(:reload)
          allow(Manage).to receive(:can_manage_game?) { true }
          allow(dispatcher).to receive(:queue_event)
        end
          
        it "should load the plugin" do
          expect(plugin_manager).to receive(:load_plugin).with("foo")
          @handler.handle
        end
          
        it "should unload the plugin" do
          expect(plugin_manager).to receive(:unload_plugin).with("foo")
          @handler.handle
        end
          
        it "should notify the client" do
          expect(@client).to receive(:emit_success).with('manage.plugin_loaded')
          @handler.handle
        end
          
        it "should reload the help" do
          expect(Help).to receive(:reload_help)
          @handler.handle
        end
        
        it "should reload the config" do
          expect(config_reader).to receive(:validate_game_config)
          expect(config_reader).to receive(:load_game_config)
          @handler.handle
        end
          
        it "should notify client if plugin not found" do
          allow(plugin_manager).to receive(:load_plugin) { raise SystemNotFoundException }
          expect(@client).to receive(:emit_failure).with('manage.plugin_not_found')
          @handler.handle
        end
          
        it "should notify client if plugin load has an error" do
          allow(plugin_manager).to receive(:load_plugin) { raise "Error" }
          expect(@client).to receive(:emit_failure).with('manage.error_loading_plugin')
          @handler.handle
        end
        
        it "should send the config updated event" do
          expect(dispatcher).to receive(:queue_event) do |event|
            expect(event.class).to eq ConfigUpdatedEvent
          end
          @handler.handle
        end
        
        it "should fail if no permissions" do
          allow(Manage).to receive(:can_manage_game?).with(@enactor) { false }
          expect(@client).to receive(:emit_failure).with('dispatcher.not_allowed')
          @handler.handle
        end
        
        it "should succeed and alert permissions are mis-configured" do
          allow(Manage).to receive(:can_manage_game?).with(@enactor) { raise "Error" }
          expect(@client).to receive(:emit_failure).with('manage.management_config_messed_up')
          expect(plugin_manager).to receive(:load_plugin).with("foo")
          @handler.handle
        end
        
        it "should still load even if the unload failed" do
          allow(plugin_manager).to receive(:unload_plugin) { raise SystemNotFoundException }
          expect(plugin_manager).to receive(:load_plugin).with("foo")
          @handler.handle
        end
        
        it "should reload locale" do
          expect(locale).to receive(:reload)
          @handler.handle
        end
        
        it "should warn if config is bad but still proceed with the load" do
          expect(config_reader).to receive(:validate_game_config) { raise "Error" }
          expect(config_reader).to receive(:load_game_config)
          expect(plugin_manager).to receive(:load_plugin).with("foo")
          expect(@client).to receive(:emit_failure).with("manage.game_config_invalid")
          @handler.handle
        end        
      end
    end
  end
end
