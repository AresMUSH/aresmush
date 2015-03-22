module AresMUSH
  module FS3Combat
    describe FS3Combat do
      
      before do
        @combat1 = CombatInstance.new(nil)
        @combat2 = CombatInstance.new(nil)
        
        @combat1.join("Bob", "soldier")
        @combat1.join("Harvey", "soldier")
        @combat2.join("Mary", "soldier")
        
        FS3Combat.combats = [
          @combat1, @combat2
        ]
      end
      
      describe :combat do
        it "should find a combat for a char" do
          FS3Combat.combat("Bob").should eq @combat1
          FS3Combat.combat("Harvey").should eq @combat1
          FS3Combat.combat("Mary").should eq @combat2          
        end
        
        it "should return nil for combat if not in combat" do
          FS3Combat.combat("Jane").should be_nil
        end
      end
      
      describe :is_in_combat? do
        it "should return true if in combat" do
          FS3Combat.is_in_combat?("Harvey").should be_true
        end
        
        it "should return false if not in combat" do
          FS3Combat.is_in_combat?("Jane").should be_false
        end
      end
    end
  end
end