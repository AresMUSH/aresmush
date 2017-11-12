module AresMUSH
  module FS3Combat
    describe Combat do
      
      before do
        @instance = Combat.new
        @instance.stub(:save) { }
        @instance.stub(:log) { }
        @bob = double
        @bob.stub(:name) { "Bob" }
        
        @harvey = double
        @harvey.stub(:name) { "Harvey" }
        
        @instance.stub(:combatants) { [ @bob, @harvey ] }
        
        SpecHelpers.stub_translate_for_testing
      end
      
            
      describe :has_combatant? do
        it "should return true if there is someone with the name" do
          @instance.has_combatant?("Bob").should be true
          @instance.has_combatant?("bOb").should be true
        end
        
        it "should return false if there is not someone with the name" do
          @instance.has_combatant?("Jane").should be false
        end
      end
      
      describe :find_combatant do
        it "should find combatant is someone with the name" do
          @instance.find_combatant("Bob").should eq @bob
        end
        
        it "should return nil if there is not someone with the name" do
          @instance.find_combatant("Jane").should be_nil
        end
      end
    end
  end
end