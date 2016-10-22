module AresMUSH
  module FS3Combat
    describe FS3Combat do
      
      
      describe :determine_damage do
        before do 
          @combatant.stub(:hitloc_severity).with("Head") { "Normal" }
          FS3Combat.stub(:weapon_stat).with("Knife", "lethality") { 0 }
          @combatant.stub(:rand) { 45 }
        end
  
        it "should determine random damage" do
          @combatant.determine_damage("Head", "Knife").should eq "M"
        end
  
        it "should account for lethality" do
          FS3Combat.stub(:weapon_stat).with("Knife", "lethality") { 40 }
          @combatant.determine_damage("Head", "Knife").should eq "S"
        end

        it "should account for hitloc severity for vital" do
          FS3Combat.stub(:weapon_stat).with("Knife", "lethality") { 25 }
          @combatant.stub(:hitloc_severity).with("Head") { "Vital" }
          @combatant.determine_damage("Head", "Knife").should eq "S"
        end

        it "should account for hitloc severity for critical" do
          @combatant.stub(:hitloc_severity).with("Head") { "Critical" }
          FS3Combat.stub(:weapon_stat).with("Knife", "lethality") { 10 }
          @combatant.determine_damage("Head", "Knife").should eq "S"
        end
  
        it "should account for armor" do
          @combatant.determine_damage("Head", "Knife", 5).should eq "L"
        end
      end
      
      
      describe :attack_target do    
        before do
          @target = double
          @target.stub(:name) { "Target" }
          @combatant.stub(:weapon) { "Knife" }
          @target.stub(:stance) { "Normal" }
          @target.stub(:determine_armor) { 0 }
          FS3Combat.stub(:weapon_stat).with("Knife", "recoil") { 1 }
        end
            
        it "should dodge if defense roll greater" do
          @target.stub(:roll_defense) { 2 }
          @combatant.stub(:roll_attack) { 1 }
          @combatant.attack_target(@target).should eq "fs3combat.attack_dodged"
        end

        it "should miss if attack roll fails" do
          @target.stub(:roll_defense) { 2 }
          @combatant.stub(:roll_attack) { 0 }
          @combatant.attack_target(@target).should eq "fs3combat.attack_missed"
        end
      
        describe "cover" do
          before do
            @target.stub(:stance) { "Cover" }
            @target.stub(:roll_defense) { 2 }
            @target.stub(:do_damage) { }
            @target.stub(:determine_damage) { }
            @target.stub(:determine_hitloc) { }
          
            # Note:  By seeding the random number generator, we can avoid the randomness.
            #   22 makes the first random number 4.
            #   220 makes the first random number 92.
            Kernel.srand 22
          end
        
          it "should miss cover if margin high enough" do
            @combatant.stub(:roll_attack) { 5 }
            @combatant.attack_target(@target).should eq "fs3combat.attack_hits"
          end

          it "should miss cover if margin is low but random die roll high" do
            Kernel.srand 220
            @combatant.stub(:roll_attack) { 2 }
            @combatant.attack_target(@target).should eq "fs3combat.attack_hits"
          end

          it "should hit cover if margin and random die roll low" do
            @combatant.stub(:roll_attack) { 2 }
            @combatant.attack_target(@target).should eq "fs3combat.attack_hits_cover"
          end
        end

        describe "success" do
          before do
            @combatant.stub(:roll_attack) { 3 }
            @target.stub(:roll_defense) { 2 }              
            @target.stub(:determine_hitloc) { "Head" }
            @combatant.stub(:weapon) { "Knife" }
            FS3Combat.stub(:weapon_is_stun?).with("Knife") { false }
            @target.stub(:do_damage)
            @target.stub(:determine_damage) { "M" }
          end
    
          describe "armor" do
            it "should be stopped completely by armor if armor value >= 100" do
              @target.stub(:determine_armor) { 101 }
              @target.should_not_receive(:do_damage)
              @combatant.attack_target(@target).should eq "fs3combat.attack_stopped_by_armor"              
            end
        
            it "should reduce damage by armor if it applies" do
              @target.stub(:determine_armor) { 10 }
              @target.should_receive(:determine_damage).with("Head", "Knife", 10) { "M" }
              @combatant.attack_target(@target).should eq "fs3combat.attack_hits" 
            end
          end
      
          describe "single fire" do
            it "should hit if attack roll greater" do
              @combatant.attack_target(@target).should eq "fs3combat.attack_hits"
            end
  
            it "should determine hitloc based on successes" do
              @target.should_receive(:determine_hitloc).with(1) { "Body" }
              @combatant.attack_target(@target)
            end
    
            it "should inflict damage" do
              @target.should_receive(:do_damage).with("M", "Knife", "Head")
              @combatant.attack_target(@target)
            end
    
            it "should calculate damage" do
              @target.should_receive(:determine_damage).with("Head", "Knife", 0) { "M" }
              @combatant.attack_target(@target)
            end
          
            it "should inflict recoil" do
              @combatant.stub(:recoil) { 2 }
              @combatant.should_receive(:recoil=).with(3)
              @combatant.attack_target(@target)
            end
          end
    
          describe "called shot" do              
            it "should hit the desired location if margin > 2" do
              @target.stub(:roll_defense) { 0 }
              @target.should_not_receive(:determine_hitloc)
              @target.should_receive(:do_damage).with("M", "Knife", "Right Leg")
              @combatant.attack_target(@target, "Right Leg")
            end
      
            it "should roll random hitloc with penalty if margin <= 2" do
              @target.should_receive(:determine_hitloc).with(-1) { "Body" }
              @target.should_receive(:do_damage).with("M", "Knife", "Body")
              @combatant.attack_target(@target, "Right Leg")
            end
          end
        end
      end
    end
  end
end