module AresMUSH
  module FS3Combat
    describe FS3Combat do
      include MockClient
      
      before do
        Global.stub(:config) { 
          { 
            "fs3combat" => 
              { "toughness_attribute" => "Body",
                "damage_mods" => { "H" => 0, "L" => 1, "M" => 2  } },
             
          } 
        }
      end
        
      describe :print_damage do
        it "should print the right damage" do
          FS3Combat.print_damage(0).should eq "----"
          FS3Combat.print_damage(0.25).should eq "X---"
          FS3Combat.print_damage(1.0).should eq "X---"
          FS3Combat.print_damage(1.25).should eq "XX--"
          FS3Combat.print_damage(2.25).should eq "XXX-"
          FS3Combat.print_damage(3.25).should eq "XXXX"
          FS3Combat.print_damage(5).should eq "XXXX"
        end
      end
      
      describe :heal_wounds do
        before do
          @char = double
          @char.stub(:name) { "Bob" }
          @damage1 = double
          @damage2 = double
          @wounds =  [@damage1, @damage2]
        end
        
        it "should apply healing points based on half successes" do
          FS3Skills.stub(:one_shot_roll) { { :successes => 0 }}
          @damage1.should_receive(:heal).with(2, true)
          @damage2.should_receive(:heal).with(2, true)
          FS3Combat.heal_wounds(@char, @wounds, 3)
        end
        
        it "should add a body roll to the healing points" do
          FS3Skills.should_receive(:one_shot_roll).with(nil, @char, { :ability => "Body", :ruling_attr => "Body" } ) { { :successes => 2 }}
          @damage1.should_receive(:heal).with(3, true)
          @damage2.should_receive(:heal).with(3, true)        
          FS3Combat.heal_wounds(@char, @wounds, 3)
        end
        
        it "should not mark wounds as treated if no healing points" do
          FS3Skills.stub(:one_shot_roll) { { :successes => 1 }}
          @damage1.should_receive(:heal).with(1, false)
          @damage2.should_receive(:heal).with(1, false)        
          FS3Combat.heal_wounds(@char, @wounds, 0)
        end
      end
      
      describe :total_damage_mod do
        it "should count wound levels" do
          wounds = [ Damage.new(:current_severity => "H"),
          Damage.new(:current_severity => "L"),
          Damage.new(:current_severity => "M") ]
          FS3Combat.total_damage_mod(wounds).should eq 3
        end

        it "should count empty damage" do
          wounds = []
          FS3Combat.total_damage_mod(wounds).should eq 0
        end
      end
    end
  end
end