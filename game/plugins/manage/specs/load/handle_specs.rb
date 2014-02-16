require_relative "../../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadCmd do
      include CommandTestHelper
  
      before do
        init_handler(LoadCmd, "load foo")
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :handle do
        context "load config" do
          before do
            @config_reader = double
            Global.stub(:config_reader) { @config_reader }
            init_handler(LoadCmd, "load config")
          end

          it "should load config and notify client" do           
            @config_reader.should_receive(:read) {}
            client.should_receive(:emit_success).with('manage.config_loaded')
            handler.handle
          end
          
          it "should handle errors from config load" do
            @config_reader.should_receive(:read) { raise "Error" }
            client.should_receive(:emit_failure).with('manage.error_loading_config')
            handler.handle
          end          
        end
        
        context "load plugin" do
          before do
            @plugin_manager = double
            @locale = double
            Global.stub(:plugin_manager) { @plugin_manager }
            Global.stub(:locale) { @locale }
            
            init_handler(LoadCmd, "load foo")
            
            AresMUSH.stub(:remove_const) {}
            client.stub(:emit_success)
            @plugin_manager.stub(:load_plugin) {}
            @locale.stub(:load!) {}
          end
          
          it "should load the plugin" do
            @plugin_manager.should_receive(:load_plugin).with("foo")
            handler.handle
          end
          
          it "should unload the plugin" do
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
end