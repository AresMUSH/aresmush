module AresMUSH
  module FS3Combat
    describe Combatant do
      before do
        @combatant = Combatant.new
        @char = double
        @combatant.stub(:character) { @char }
      end
      
      describe :inflict_damage do
        it "should inflict damage on a PC" do
          FS3Combat.should_receive(:inflict_damage).with(@char, "M", "Test", true) {}
          @combatant.inflict_damage("M", "Test", true)
        end
        
        it "should inflict damage on a NPC" do
          @combatant.stub(:character) { nil }
          @combatant.inflict_damage("M", "Test", true)
          @combatant.inflict_damage("L", "Test", true)
          @combatant.npc_damage[0].should eq "M"
          @combatant.npc_damage[1].should eq "L"
        end
      end
      
      describe :total_damage_mod do
        it "should total damage for a PC" do
          damage = [ Damage.new(current_severity: "L"),
                     Damage.new(current_severity: "M") ]
          @char.stub(:damage) { damage }
          FS3Combat.should_receive(:total_damage_mod).with(damage) { 2 }
          @combatant.total_damage_mod.should eq 2
        end
        
        it "should total damage for a NPC" do
          @combatant.stub(:character) { nil }
          @combatant.stub(:npc_damage) { ["L", "M"] }
          FS3Combat.should_receive(:total_damage_mod).with(anything) do |wounds|
            wounds[0].current_severity.should eq "L"
            wounds[1].current_severity.should eq "M"
            3
          end
          @combatant.total_damage_mod.should eq 3
        end
      end
      
      describe :roll_ability do
        
        it "should roll the specified ability for a PC" do
          FS3Skills.should_receive(:one_shot_roll).with(nil, @char, anything) do |client, char, params|
            params.ability.should eq "Firearms"
            params.modifier.should eq 3
            params.ruling_attr.should be_nil
            result = { :successes => 2, :success_title => "Foo" }
            result
          end
          @combatant.roll_ability("Firearms", 3).should eq 2
        end
        
        it "should roll just a number for a NPC" do
          @combatant.stub(:character) { nil }
          result = { :successes => 2, :success_title => "Foo" }
          FS3Skills.should_receive(:one_shot_die_roll).with(@combatant.npc_skill + 3) { result }
          @combatant.roll_ability("Firearms", 3).should eq 2
        end
      end
    end
  end
end