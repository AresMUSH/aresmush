$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  module EventHandlers
    class TestCommand
      include Plugin
    end
  end
end

module AresMUSH

  describe PluginFactory do
    describe :create_plugin_classes do
      before do
        @factory = PluginFactory.new      
      end
      
      it "creates instances of each plugin class" do
        plugins = @factory.create_plugin_classes
        test_plugin = plugins.select { |p| p.kind_of?(AresMUSH::EventHandlers::TestCommand) }
        test_plugin.should_not be_nil
      end
    end
    
  end
end

