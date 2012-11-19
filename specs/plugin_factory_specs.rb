$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  module EventHandlers
    class TestCommand
      include AresMUSH::Plugin
    end
  end
end

module AresMUSH

  describe PluginFactory do
    describe :create_plugin_classes do
      
      it "creates instances of each plugin class" do
        factory = PluginFactory.new
        plugins = factory.create_plugin_classes
        test_plugin = plugins.select { |p| p.kind_of?(AresMUSH::EventHandlers::TestCommand) }
        test_plugin.should_not be_nil
      end
      
      it "sets the plugin's container" do
        factory = PluginFactory.new
        container = double(Container)
        factory.container = container
        plugins = factory.create_plugin_classes
        plugins[0].container.should eq container
      end      
    end
    
  end
end

