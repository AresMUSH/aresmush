require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadHelpCmd do
      include PluginCmdTestHelper
  
      before do
        init_handler(LoadHelpCmd, "load help")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that requires login"

      describe :handle do
        before do
          @help_reader = double
          Global.stub(:help_reader) { @help_reader }
        end

        it "should load help and notify client" do           
          @help_reader.should_receive(:read) {}
          client.should_receive(:emit_success).with('manage.help_loaded')
          handler.handle
        end
          
        it "should handle errors from help load" do
          @help_reader.should_receive(:read) { raise "Error" }
          client.should_receive(:emit_failure).with('manage.error_loading_help')
          handler.handle
        end          
      end
    end
  end
end