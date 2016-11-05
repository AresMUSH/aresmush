module AresMUSH
  module FS3Combat
    describe FS3Combat do
      
      before do
        Global.stub(:read_config).with("fs3combat", "recovery_skill") { "Body" }
        Global.stub(:read_config).with("fs3combat", "treat_skill") { "First Aid" }
        SpecHelpers.stub_translate_for_testing        
      end
        
      describe :print_damage do
        it "should print the right damage" do
          FS3Combat.print_damage(-0).should eq "%xr%xn----"
          FS3Combat.print_damage(-0.25).should eq "%xrX%xn---"
          FS3Combat.print_damage(-1.0).should eq "%xrX%xn---"
          FS3Combat.print_damage(-1.25).should eq "%xrXX%xn--"
          FS3Combat.print_damage(-2.25).should eq "%xrXXX%xn-"
          FS3Combat.print_damage(-3.25).should eq "%xrXXXX%xn"
          FS3Combat.print_damage(-5).should eq "%xrXXXX%xn"
        end
      end
      
      describe :total_damage_mod do
        it "should count all wound levels" do
          damage1 = double
          damage2 = double
          damage1.stub(:wound_mod) { 1 }
          damage2.stub(:wound_mod) { 2 }
          wounds = [ damage1, damage2 ]
          char = double
          char.stub(:damage) { wounds }
          FS3Combat.total_damage_mod(char).should eq -3
        end

        it "should count empty damage" do
          char = double
          char.stub(:damage) { [] }
          FS3Combat.total_damage_mod(char).should eq 0
        end        
      end
      
      describe :heal_wounds do
        before do
          @char = double
          @char.stub(:name) { "Bob" }
          @damage1 = double
          @damage2 = double
          @damage1.stub(:healing_points) { 2 }
          @damage2.stub(:healing_points) { 2 }
          @wounds =  [@damage1, @damage2]
          FS3Combat.stub(:is_in_hospital?) { false }
          @char.stub(:doctors) { [] }
          @char.stub(:damage) { @wounds }
          FS3Skills::Api.stub(:one_shot_roll) { { :successes => 0 } }
        end
        
        it "should apply a base of 1 healing point to each wound" do
          FS3Combat.should_receive(:heal).with(@damage1, 1)
          FS3Combat.should_receive(:heal).with(@damage2, 1)
          FS3Combat.heal_wounds(@char)
        end
        
        it "should add a recovery roll to the healing points" do
          FS3Skills::Api.should_receive(:one_shot_roll) do |client, char, roll_params|
            client.should be_nil
            char.should eq @char
            roll_params.ability.should eq "Body"
            { :successes => 4 }
          end
          FS3Combat.should_receive(:heal).with(@damage1, 2)
          FS3Combat.should_receive(:heal).with(@damage2, 2)
          FS3Combat.heal_wounds(@char)
        end
        
        it "should add 1 if in hospital" do
          FS3Combat.stub(:is_in_hospital?) { true }
          FS3Combat.should_receive(:heal).with(@damage1, 2)
          FS3Combat.should_receive(:heal).with(@damage2, 2)
          FS3Combat.heal_wounds(@char)
        end

        it "should add 1 if under doctor's care" do
          doctor = double
          doctor.stub(:name) { "Dr. Carter" }
          @char.stub(:doctors) { [doctor] }
          FS3Combat.should_receive(:heal).with(@damage1, 2)
          FS3Combat.should_receive(:heal).with(@damage2, 2)
          FS3Combat.heal_wounds(@char)
        end
        
        it "should only add 1 if under both doctor and hospital" do
          doctor = double
          doctor.stub(:name) { "Dr. Carter" }
          FS3Combat.stub(:is_in_hospital?) { true }
          @char.stub(:doctors) { [doctor] }
          FS3Skills::Api.stub(:one_shot_roll) { { :successes => 3 } }
          FS3Combat.should_receive(:heal).with(@damage1, 2)
          FS3Combat.should_receive(:heal).with(@damage2, 2)
          FS3Combat.heal_wounds(@char)
        end
      end
      
      
      describe :heal do
        before do
          Global.stub(:read_config).with("fs3combat", "healing_points", "GRAZE") { 5 }
          Global.stub(:read_config).with("fs3combat", "healing_points", "HEAL") { 0 }
          @damage = double
          @damage.stub(:is_stun) { false }
          @damage.stub(:save)
        end
        
        it "should not touch a healed wound" do
          @damage.stub(:healing_points) { 0 }
          @damage.should_not_receive(:save)
          FS3Combat.heal(@damage, 1)
        end
        
        it "should subtract healing points" do
          @damage.stub(:healing_points) { 5 }
          @damage.should_receive(:update).with(healing_points: 3)
          @damage.should_receive(:update).with(healed: true)
          FS3Combat.heal(@damage, 2)          
        end
        
        it "should triple healing points for a stun wound" do
          @damage.stub(:healing_points) { 8 }
          @damage.stub(:is_stun) { true }
          @damage.should_receive(:update).with(healing_points: 2)
          @damage.should_receive(:update).with(healed: true)
          FS3Combat.heal(@damage, 2)          
        end
        
        it "should lower severity and reset points when a wound gets enough healing points" do
          @damage.stub(:healing_points) { 2 }
          @damage.stub(:current_severity) { "FLESH" }
          @damage.should_receive(:update).with(healing_points: 5)
          @damage.should_receive(:update).with(healed: true)
          @damage.should_receive(:update).with(current_severity: "GRAZE")
          FS3Combat.heal(@damage, 2)  
        end
        
        it "should reset healing points for a healed wound" do
          @damage.stub(:healing_points) { 2 }
          @damage.stub(:current_severity) { "GRAZE" }
          @damage.should_receive(:update).with(healing_points: 0)
          @damage.should_receive(:update).with(healed: true)
          @damage.should_receive(:update).with(current_severity: "HEAL")
          FS3Combat.heal(@damage, 3)  
        end
      end
      
      describe :worst_treatable_wound do
        before do
          @char = double
          @damage1 = double
          @damage2 = double
          @damage3 = double
          
          @damage1.stub(:current_severity) { "GRAZE" }
          @damage2.stub(:current_severity) { "INCAP" }
          @damage3.stub(:current_severity) { "IMPAIR" }
          
          @damage1.stub(:is_treatable?) { true }
          @damage2.stub(:is_treatable?) { true }
          @damage3.stub(:is_treatable?) { true }
        end
        
        it "should return the most serious wound if all treatable" do          
          @char.stub(:damage) { [@damage1, @damage2, @damage3] }
          FS3Combat.worst_treatable_wound(@char).should eq @damage2
        end
        
        it "should ignore treated wounds" do
          @damage2.stub(:is_treatable?) { false }
          @char.stub(:damage) { [@damage1, @damage2, @damage3] }
          FS3Combat.worst_treatable_wound(@char).should eq @damage3
        end
        
        it "should return nil if no treatable wounds" do
          @damage1.stub(:is_treatable?) { false }
          @damage2.stub(:is_treatable?) { false }
          @damage3.stub(:is_treatable?) { false }
          @char.stub(:damage) { [@damage1, @damage2, @damage3] }
          FS3Combat.worst_treatable_wound(@char).should be_nil
        end
        
      end
      
      describe :treat do
        before do 
          @patient = double
          @doctor = double
          
          @patient.stub(:name) { "Bob" }
          @doctor.stub(:name) { "Doc" }
          FS3Combat.stub(:combat)
          @damage = double
          FS3Combat.stub(:worst_treatable_wound) { @damage }
        end
        
        it "should not do anything if no treatable wounds" do
          FS3Combat.should_receive(:worst_treatable_wound).with(@patient) { nil }
          FS3Combat.should_not_receive(:heal)
          FS3Combat.treat(@patient, @doctor).should eq "fs3combat.no_treatable_wounds"
        end
        
        it "should add a healing point if treat roll successful" do
          Global.stub(:read_config).with("fs3combat", "treat_skill") { "Medicine" }
          @doctor.should_receive(:roll_ability).with("Medicine") { { successes: 2 }}
          
          FS3Combat.should_receive(:heal).with(@damage, 1)
          FS3Combat.treat(@patient, @doctor).should eq "fs3combat.treat_success"
        end
        
        it "should not heal if treat roll unsuccessful" do
          Global.stub(:read_config).with("fs3combat", "treat_skill") { "Medicine" }
          @doctor.should_receive(:roll_ability).with("Medicine") { { successes: 0 }}
          
          FS3Combat.should_not_receive(:heal)
          FS3Combat.treat(@patient, @doctor).should eq "fs3combat.treat_failed"
        end
      end
    end
  end
end