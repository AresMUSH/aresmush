require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadPluginCmd do
      include PluginCmdTestHelper
  
      before do
        init_handler(LoadPluginCmd, "load foo")
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
          handler.validate_load_target.should eq 'manage.invalid_load_syntax'
        end
        
        it "should accept command otherwise" do
          handler.stub(:load_target) { "foo" }
          handler.validate_load_target.should eq nil
        end
      end
      
      describe :handle do
        
        before do
          @plugin_manager = double
          @locale = double
          @config_reader = double
          Global.stub(:plugin_manager) { @plugin_manager }
          Global.stub(:locale) { @locale }
          Global.stub(:config_reader) { @config_reader }
            
          handler.crack!
            
          AresMUSH.stub(:remove_const)
          client.stub(:emit_success)
          @plugin_manager.stub(:load_plugin)
          @locale.stub(:load!)
          @config_reader.stub(:read)
        end
          
        it "should load the plugin" do
          @plugin_manager.should_receive(:load_plugin).with("foo")
          handler.handle
        end
          
        it "should unload the plugin if it exists" do
          AresMUSH.should_receive(:const_defined?).with("Foo") { true }
          AresMUSH.should_receive(:remove_const).with("Foo")
          handler.handle
        end
          
        it "should notify the client" do
          client.should_receive(:emit_success).with('manage.plugin_loaded')
          handler.handle
        end
          
        it "should reload the locale" do
          @locale.should_receive(:load!)
          handler.handle
        end
        
        it "should reload the config" do
          @config_reader.should_receive(:read)
          handler.handle
        end
          
        it "should notify client if plugin not found" do
          @plugin_manager.stub(:load_plugin) { raise SystemNotFoundException }
          client.should_receive(:emit_failure).with('manage.plugin_not_found')
          handler.handle
        end
          
        it "should notify client if plugin load has an error" do
          @plugin_manager.stub(:load_plugin) { raise "Error" }
          client.should_receive(:emit_failure).with('manage.error_loading_plugin')
          handler.handle
        end
      end
    end
  end
end