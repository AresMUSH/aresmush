module AresMUSH
  module FS3Combat
    describe FS3Combat do
      include MockClient
      
      before do
        @combat1 = { "Bob" => { :ammo => 2 }, "Harvey" => { :ammo => 3 } }
        @combat2 = { "Mary" => { :ammo => 1 } }
        FS3Combat.combats = [
          @combat1, @combat2
        ]
      end
      
      describe :index do
        it "should find a combat index for a char" do
          FS3Combat.index("Bob").should eq 0
          FS3Combat.index("Harvey").should eq 0
          FS3Combat.index("Mary").should eq 1
        end

        it "should return nil for index if not in combat" do
          FS3Combat.index("Jane").should be_nil
        end
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
      
      describe :stat do        
        it "should find a stat for a char" do
          FS3Combat.stat("Bob", :ammo).should eq 2
          FS3Combat.stat("Harvey", :ammo).should eq 3
          FS3Combat.stat("Mary", :ammo).should eq 1
        end
        
        it "should return nil for stat if not in combat" do
          FS3Combat.stat("Jane", :ammo).should be_nil          
        end

        it "should return nil if stat not set" do
          FS3Combat.stat("Mary", :target).should be_nil
        end
      end
      
      describe :set_stat do
        it "should set a stat for someone in combat" do
          FS3Combat.set_stat("Bob", :ammo, 45)
          FS3Combat.stat("Bob", :ammo).should eq 45

          FS3Combat.set_stat("Mary", :foo, 44)
          FS3Combat.stat("Mary", :foo).should eq 44
        end
        
        it "should raise error if someone's not in combat" do
          expect { FS3Combat.set_stat("Jane", :ammo, 45) }.to raise_error
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