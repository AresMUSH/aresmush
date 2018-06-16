module AresMUSH
  module FS3Combat
    describe Combat do
      
      before do
        @instance = Combat.new
        allow(@instance).to receive(:save) { }
        allow(@instance).to receive(:log) { }
        @bob = double
        allow(@bob).to receive(:name) { "Bob" }
        
        @harvey = double
        allow(@harvey).to receive(:name) { "Harvey" }
        
        allow(@instance).to receive(:combatants) { [ @bob, @harvey ] }
        
        stub_translate_for_testing
      end
      
            
      describe :has_combatant? do
        it "should return true if there is someone with the name" do
          expect(@instance.has_combatant?("Bob")).to be true
          expect(@instance.has_combatant?("bOb")).to be true
        end
        
        it "should return false if there is not someone with the name" do
          expect(@instance.has_combatant?("Jane")).to be false
        end
      end
      
      describe :find_combatant do
        it "should find combatant is someone with the name" do
          expect(@instance.find_combatant("Bob")).to eq @bob
        end
        
        it "should return nil if there is not someone with the name" do
          expect(@instance.find_combatant("Jane")).to be_nil
        end
      end
    end
  end
end
