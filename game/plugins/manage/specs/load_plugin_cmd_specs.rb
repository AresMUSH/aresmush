require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadPluginCmd do
      include CommandHandlerTestHelper
      include GlobalTestHelper
  
      before do
        init_handler(LoadPluginCmd, "load foo")
        SpecHelpers.stub_translate_for_testing
        stub_global_objects
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :crack! do
        it "should set the load target" do          
          handler.crack!
          handler.load_target.should eq 'foo'
        end
      end
      
      describe :handle do
        
        before do
          handler.crack!
            
          client.stub(:emit_success)
          client.stub(:emit_ooc)
          plugin_manager.stub(:load_plugin)
          plugin_manager.stub(:unload_plugin)
          Help::Interface.stub(:load_help)
          client_monitor.stub(:reload_clients)
          Manage.stub(:can_manage_game?) { true }
        end
          
        it "should load the plugin" do
          plugin_manager.should_receive(:load_plugin).with("foo")
          handler.handle
        end
          
        it "should unload the plugin xxxx" do
          plugin_manager.should_receive(:unload_plugin).with("foo")
          handler.handle
        end
          
        it "should notify the client" do
          client.should_receive(:emit_success).with('manage.plugin_loaded')
          handler.handle
        end
          
        it "should reload the help" do
          Help::Interface.should_receive(:load_help)
          handler.handle
        end
          
        it "should notify client if plugin not found" do
          plugin_manager.stub(:load_plugin) { raise SystemNotFoundException }
          client.should_receive(:emit_failure).with('manage.plugin_not_found')
          handler.handle
        end
          
        it "should notify client if plugin load has an error" do
          plugin_manager.stub(:load_plugin) { raise "Error" }
          client.should_receive(:emit_failure).with('manage.error_loading_plugin')
          handler.handle
        end
        
        it "should fail if no permissions" do
          Manage.stub(:can_manage_game?).with(char) { false }
          client.should_receive(:emit_failure).with('dispatcher.not_allowed')
          handler.handle
        end
        
        it "should succeed and alert permissions are mis-configured" do
          Manage.stub(:can_manage_game?).with(char) { raise "Error" }
          client.should_receive(:emit_failure).with('manage.management_config_messed_up')
          plugin_manager.should_receive(:load_plugin).with("foo")
          handler.handle
        end
        
        it "should still load even if the unload failed" do
          plugin_manager.stub(:unload_plugin) { raise SystemNotFoundException }
          plugin_manager.should_receive(:load_plugin).with("foo")
          handler.handle
        end
        
        it "should reload the clients" do
          client_monitor.should_receive(:reload_clients)
          handler.handle
        end
      end
    end
  end
end