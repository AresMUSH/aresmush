require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe UnloadPluginCmd do
      include GlobalTestHelper
  
      before do
        @client = double
        @handler = UnloadPluginCmd.new(@client, nil, nil)
        SpecHelpers.stub_translate_for_testing
        stub_global_objects
      end
      
      describe :handle do
        
        before do
          @handler.load_target = "foo"
            
          @client.stub(:emit_success)
          plugin_manager.stub(:unload_plugin)
          Help.stub(:reload_help)
        end
          
        it "should unload the plugin" do
          plugin_manager.should_receive(:unload_plugin).with("foo")
          @handler.handle
        end
          
        it "should notify the client" do
          @client.should_receive(:emit_success).with('manage.plugin_unloaded')
          @handler.handle
        end

        it "should notify client if plugin not found" do
          plugin_manager.stub(:unload_plugin) { raise SystemNotFoundException }
          @client.should_receive(:emit_failure).with('manage.plugin_not_found')
          @handler.handle
        end
          
        it "should notify client if plugin unload has an error" do
          plugin_manager.stub(:unload_plugin) { raise "Error" }
          @client.should_receive(:emit_failure).with('manage.error_unloading_plugin')
          @handler.handle
        end
      end
    end
  end
end