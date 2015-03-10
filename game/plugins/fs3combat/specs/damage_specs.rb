module AresMUSH
  module FS3Combat
    describe FS3Combat do
      include MockClient
      
      describe :heal_wounds do
        before do
          @char = Character.new
          @char.combat_damage = [
            {
              "current_severity" => "L",
              "healing_points" => 1
            },
            {
              "current_severity" => "H",
              "healing_points" => 0
            },
            {
              "current_severity" => "S",
              "healing_points" => 2
            },
            {
              "current_severity" => "C",
              "healing_points" => 10
            },
            {
              "current_severity" => "S",
              "healing_points" => 7
            }
          ]
          Global.stub(:config) { { "fs3combat" => { } } }
          FS3Skills.stub(:one_shot_roll) { { :successes => 0 }}
        end
        
        it "should not touch a healed wound" do
          FS3Combat.heal_wounds(@char, 1)
          @char.combat_damage[1]["healing_points"].should eq 0
          @char.combat_damage[1]["current_severity"].should eq "H"
        end
        
        it "should lower severity and reset points when a wound gets enough healing points" do
          FS3Combat.heal_wounds(@char, 4)
          @char.combat_damage[2]["healing_points"].should eq 3
          @char.combat_damage[2]["current_severity"].should eq "M"
        end
        
        it "should not reset healing points for a completely healed wound" do
          FS3Combat.heal_wounds(@char, 4)
          @char.combat_damage[0]["healing_points"].should eq 0
          @char.combat_damage[0]["current_severity"].should eq "H"
        end
        
        it "should apply healing points based on half successes" do
          FS3Combat.heal_wounds(@char, 3)
          @char.combat_damage[3]["healing_points"].should eq 8
        end
        
        it "should heal multiple wounds" do
          FS3Combat.heal_wounds(@char, 1)
          @char.combat_damage[3]["healing_points"].should eq 9
          @char.combat_damage[4]["healing_points"].should eq 6
        end
        
        it "should add a body roll to the healing points" do
          FS3Skills.stub(:one_shot_roll) { { :successes => 1 }}
          FS3Combat.heal_wounds(@char, 4)
          @char.combat_damage[3]["healing_points"].should eq 7          
        end
      end
    end
  end
end