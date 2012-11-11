$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  module EventHandlers
    class TestCommand
      include AresMUSH::Addon
    end
  end
end

module AresMUSH

  describe AddonFactory do
    describe :create_addon_classes do
      it "creates instances of each addon class" do
        factory = AddonFactory.new
        addons = factory.create_addon_classes
        addons.count.should eq 1
        addons[0].should be_a(AresMUSH::EventHandlers::TestCommand)
      end
      
      it "sets the addon's container" do
        factory = AddonFactory.new
        container = double(Container)
        factory.container = container
        addons = factory.create_addon_classes
        addons[0].container.should eq container
      end      
    end
    
  end
end

