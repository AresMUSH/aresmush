$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe SystemFactory do
    describe :create_system_classes do
      it "creates instances of each system class" do
        # TODO
      end
    end
    
  end
end

