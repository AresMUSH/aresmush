require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe UnloadPluginCmd do
      include PluginCmdTestHelper
  
      before do
        init_handler(UnloadPluginCmd, "unload foo")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :crack! do
        it "should set the load target" do          
          handler.crack!
          handler.load_target.should eq 'foo'
        end
      end
      
      describe :validate_load_target do
        it "should reject command if no args specified" do
          handler.stub(:load_target) { nil }
          handler.validate_load_target.should eq 'dispatcher.invalid_syntax'
        end
        
        it "should accept command otherwise" do
          handler.stub(:load_target) { "foo" }
          handler.validate_load_target.should eq nil
        end
      end
      
      describe :handle do
        
        before do
          @plugin_manager = double
          Global.stub(:plugin_manager) { @plugin_manager }
            
          handler.crack!
            
          client.stub(:emit_success)
          @plugin_manager.stub(:unload_plugin)
        end
          
        it "should unload the plugin" do
          @plugin_manager.should_receive(:unload_plugin).with("foo")
          handler.handle
        end
          
        it "should notify the client" do
          client.should_receive(:emit_success).with('manage.plugin_unloaded')
          handler.handle
        end

        it "should notify client if plugin not found" do
          @plugin_manager.stub(:unload_plugin) { raise SystemNotFoundException }
          client.should_receive(:emit_failure).with('manage.plugin_not_found')
          handler.handle
        end
          
        it "should notify client if plugin unload has an error" do
          @plugin_manager.stub(:unload_plugin) { raise "Error" }
          client.should_receive(:emit_failure).with('manage.error_unloading_plugin')
          handler.handle
        end
      end
    end
  end
end