$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe SystemManager do
    
    describe :load_all do
      it "loads all systems" do
        # TODO
      end
    end

    describe :load_system do
      it "loads a single system" do
        # TODO
      end
      
      it "raises an error if the system is not found" do
        # TODO
      end
      
      it "catches syntax errors" do 
        # TODO
      end
    end
    
    
  end
end

