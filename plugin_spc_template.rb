require_relative "../../plugin_test_loader"

module AresMUSH
  module PluginModule
    describe PluginClass do

      before do  
        @cmd = double
        @client = double
        @plugin = PluginClass.new  
        @plugin.cmd = @cmd
        @plugin.client = @client          
        SpecHelpers.stub_translate_for_testing        
      end
      
      describe :want_command? do
        it "should xyz" do
        end
      end
      
      describe :check do
        it "should xyz" do
        end
      end

      describe :handle do
        it "should xyz" do
        end
      end

    end
  end
end