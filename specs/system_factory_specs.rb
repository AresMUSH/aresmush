$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  module Commands
    class TestCommand
      def initialize(container)
        @container = container
      end
      
      attr_reader :container
    end
  end
end

module AresMUSH

  describe SystemFactory do
    describe :create_system_classes do
      it "creates instances of each system class" do
        factory = SystemFactory.new
        systems = factory.create_system_classes
        systems.count.should eq 1
        systems[0].should be_a(AresMUSH::Commands::TestCommand)
      end
      
      it "sets the system instance container" do
        factory = SystemFactory.new
        container = double(Container)
        factory.container = container
        systems = factory.create_system_classes
        systems[0].container.should eq container
      end
      
    end
    
  end
end

