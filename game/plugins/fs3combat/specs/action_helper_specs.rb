module AresMUSH
  module FS3Combat
    describe FS3Combat do
      
      describe :reset_actions do
        before do 
          @combatant = double
          @combatant.stub(:name) { "Trooper" }
          @combatant.stub(:update)
          @combatant.stub(:is_aiming) { false }
        end
        
        it "should reset posed" do
          @combatant.should_receive(:update).with(posed: false)
          FS3Combat.reset_actions(@combatant)
        end
        
        it "should reset recoil" do
          @combatant.should_receive(:update).with(recoil: 0)
          FS3Combat.reset_actions(@combatant)
        end
        
        it "should reset aiming if they aren't still aiming" do 
          @combatant.stub(:is_aiming) { true }
          @combatant.stub(:action) { AttackAction.new(@combatant) }
          @combatant.should_receive(:update).with(is_aiming: false)
          FS3Combat.reset_actions(@combatant)
        end

        it "should not reset aiming if they're still aiming" do 
          @combatant.stub(:is_aiming) { true }
          @combatant.stub(:action) { AimAction.new(@combatant) }
          @combatant.should_not_receive(:update).with(is_aiming: false)
          FS3Combat.reset_actions(@combatant)
        end
      end
      
      describe :ai_action do
        before do
          @combatant = double
          @client = double
          @combat = double
          @combatant.stub(:ammo) { nil }
        end
        
        it "should choose reload if out of ammo" do
          @combatant.stub(:ammo) { 0 }
          FS3Combat.should_receive(:set_action).with(@client, nil, @combat, @combatant, FS3Combat::ReloadAction, "")
          FS3Combat.ai_action(@combat, @client, @combatant)
        end

        describe "attack" do
          before do
            @target1 = double
            @target2 = double
            @target2.stub(:name) { "Bob" }
            @combatant.stub(:team) { 1 }
            @target1.stub(:team) { 1 }
            @target2.stub(:team) { 2 }
            @combat.stub(:active_combatants) { [@target1, @target2] }
          end   
                   
          it "should attack a random target from the other team" do
            FS3Combat.should_receive(:set_action).with(@client, nil, @combat, @combatant, FS3Combat::AttackAction, "Bob")
            FS3Combat.ai_action(@combat, @client, @combatant)
          end
          
          it "should do nothing if no valid target found" do
            @target2.stub(:team) { 1 }
            FS3Combat.should_not_receive(:set_action)
            FS3Combat.ai_action(@combat, @client, @combatant)
          end
        end
      end
      
      describe :determine_damage do
        before do 
          @combatant = double
          FS3Combat.stub(:hitloc_severity).with(@combatant, "Head") { "Normal" }
          FS3Combat.stub(:weapon_stat).with("Knife", "lethality") { 0 }
          FS3Combat.stub(:rand) { 25 }
        end
  
        describe "random damage" do
          it "should roll a graze" do
            FS3Combat.stub(:rand) { 29 }
            FS3Combat.determine_damage(@combatant, "Head", "Knife").should eq "GRAZE"
          end
          
          it "should roll a flesh wound" do
            FS3Combat.stub(:rand) { 69 }
            FS3Combat.determine_damage(@combatant, "Head", "Knife").should eq "FLESH"
          end
          
          it "should roll an impairing wound" do
            FS3Combat.stub(:rand) { 99 }
            FS3Combat.determine_damage(@combatant, "Head", "Knife").should eq "IMPAIR"
          end
          
          it "should roll an incap wound" do
            FS3Combat.stub(:rand) { 101 }
            FS3Combat.determine_damage(@combatant, "Head", "Knife").should eq "INCAP"
          end
        end
  
        it "should account for lethality" do
          FS3Combat.stub(:weapon_stat).with("Knife", "lethality") { 40 }
          FS3Combat.determine_damage(@combatant, "Head", "Knife").should eq "FLESH"
        end

        it "should account for hitloc severity for vital" do
          FS3Combat.stub(:hitloc_severity).with(@combatant, "Head") { "Vital" }
          FS3Combat.determine_damage(@combatant, "Head", "Knife").should eq "FLESH"
        end

        it "should account for hitloc severity for critical" do
          FS3Combat.stub(:hitloc_severity).with(@combatant, "Head") { "Critical" }
          FS3Combat.stub(:rand) { 80 }
          FS3Combat.stub(:weapon_stat).with("Knife", "lethality") { 0 }
          FS3Combat.determine_damage(@combatant, "Head", "Knife").should eq "INCAP"
        end
  
        it "should account for armor" do
          FS3Combat.stub(:rand) { 32 }
          FS3Combat.determine_damage(@combatant, "Head", "Knife", 5).should eq "GRAZE"
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