require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadLocaleCmd do
      include PluginCmdTestHelper
  
      before do
        init_handler(LoadLocaleCmd, "locale/load")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :want_command? do
        it "should want the load locale cmd" do
          cmd.stub(:root_is?).with("load") { true }
          cmd.stub(:args) { "locale" }
          handler.want_command?(client, cmd).should be_true
        end

        it "should not want another cmd" do
          cmd.stub(:root_is?).with("load") { false }
          cmd.stub(:args) { "config" }
          handler.want_command?(client, cmd).should be_false
        end

        it "should not want a different load type" do
          cmd.stub(:root_is?).with("load") { true }
          cmd.stub(:args) { "config" }
          handler.want_command?(client, cmd).should be_false
        end
      end
      
      describe :handle do        
        before do
          @locale = double
          Global.stub(:locale) { @locale }
        end
          
        it "should reload the locale and notify client" do
          @locale.should_receive(:load!)
          client.should_receive(:emit_success).with('manage.locale_loaded')
          handler.handle
        end
        
        it "should handle errors from config load" do
          @locale.should_receive(:load!) { raise "Error" }
          client.should_receive(:emit_failure).with('manage.error_loading_locale')
          handler.handle
        end     
      end
    end
  end
end