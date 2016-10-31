module AresMUSH
  module FS3Combat
    describe FS3Combat do
      before do
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :reset_actions do
        before do 
          @combatant = double
          @combatant.stub(:name) { "Trooper" }
          @combatant.stub(:update)
          @combatant.stub(:is_aiming?) { false }
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
          @combatant.stub(:is_aiming?) { true }
          @combatant.stub(:action) { AttackAction.new(@combatant, "") }
          @combatant.should_receive(:update).with(aim_target: nil)
          FS3Combat.reset_actions(@combatant)
        end

        it "should not reset aiming if they're still aiming" do 
          @combatant.stub(:is_aiming?) { true }
          @combatant.stub(:action) { AimAction.new(@combatant, "") }
          @combatant.should_not_receive(:update).with(aim_target: nil)
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
      
      describe :determine_armor do
        before do 
          @combatant = double
          @combatant.stub(:vehicle) { nil }
          @combatant.stub(:armor) { "Tactical" }
          FS3Skills::Api.stub(:one_shot_die_roll) { 0 }
          FS3Combat.stub(:weapon_stat) { 3 }
          FS3Combat.stub(:armor_stat).with("Tactical", "protection") { { "Head" => 5 } }
        end

        it "should return no protection if no armor" do
          @combatant.stub(:armor) { nil }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 0).should eq 0
        end
        
        it "should get protection from vehicle armor if in a vehicle" do
          vehicle = double
          vehicle.stub(:armor) { "Viper" }
          @combatant.stub(:vehicle) { vehicle }
          
          FS3Combat.should_receive(:armor_stat).with("Viper", "protection") { {} }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 0)
        end

        it "should get protection from combatant armor if not in a vehicle" do
          FS3Combat.should_receive(:armor_stat).with("Tactical", "protection") { {} }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 0)
        end
        
        it "should bypass armor if not a protected location" do
          FS3Combat.stub(:armor_stat).with("Tactical", "protection") { { "Chest" => 2 } }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 0).should eq 0
        end
        
        it "should roll the penetration and protection dice" do
          FS3Combat.should_receive(:weapon_stat).with("Rifle", "penetration") { 5 }
          FS3Combat.should_receive(:armor_stat).with("Tactical", "protection") { { "Head" => 2 } }
          
          FS3Skills::Api.should_receive(:one_shot_die_roll).with(5)
          FS3Skills::Api.should_receive(:one_shot_die_roll).with(2)
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 0)
        end
        
        it "should bypass armor if pen wins by enough" do
          FS3Skills::Api.stub(:one_shot_die_roll).with(5) { 2 }
          FS3Skills::Api.stub(:one_shot_die_roll).with(3) { 5 }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 0).should eq 0
        end
        
        it "should be stopped by armor if protect wins by enough" do
          FS3Skills::Api.stub(:one_shot_die_roll).with(5) { 5 }
          FS3Skills::Api.stub(:one_shot_die_roll).with(3) { 2 }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 0).should eq 100
        end

        it "should randomize protection if no decisive winner" do
          FS3Combat.stub(:rand) { 29 }
          FS3Skills::Api.stub(:one_shot_die_roll).with(5) { 4 }
          FS3Skills::Api.stub(:one_shot_die_roll).with(3) { 2 }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 0).should eq 29
        end

        it "should add in attacker successes" do
          FS3Skills::Api.stub(:one_shot_die_roll).with(5) { 2 }
          FS3Skills::Api.stub(:one_shot_die_roll).with(3) { 4 }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 1).should eq 0
        end
      end
      
      describe :determine_attack_margin do
        before do
          @combatant = double
          @target = double
          
          @combatant.stub(:name) { "A" }
          @target.stub(:name) { "D" }
          
          @combatant.stub(:recoil) { 0 }
          @combatant.stub(:weapon) { "Rifle" }
          @target.stub(:stance) { "Normal" }
        end
        
        it "should roll attack and defense" do
          FS3Combat.should_receive(:roll_attack).with(@combatant, 0) { 0 }
          FS3Combat.should_receive(:roll_defense).with(@target, "Rifle") { 0 }
          FS3Combat.determine_attack_margin(@combatant, @target, 0)
        end
        
        it "should add in an attacker modifier" do
          FS3Combat.should_receive(:roll_attack).with(@combatant, 1) { 0 }
          FS3Combat.should_receive(:roll_defense).with(@target, "Rifle") { 0 }
          FS3Combat.determine_attack_margin(@combatant, @target, 1)
        end
        
        it "should subtract recoil" do
          @combatant.stub(:recoil) { 2 }
          FS3Combat.should_receive(:roll_attack).with(@combatant, -2) { 0 }
          FS3Combat.should_receive(:roll_defense).with(@target, "Rifle") { 0 }
          FS3Combat.determine_attack_margin(@combatant, @target, 0)
        end
        
        it "should be a dodege if the defender wins" do
          FS3Combat.stub(:roll_attack) { 1 }
          FS3Combat.stub(:roll_defense) { 2 }
          result = FS3Combat.determine_attack_margin(@combatant, @target, 0)
          result[:message].should eq "fs3combat.attack_dodged"
          result[:hit].should eq false
        end
        
        it "should hit cover if defender is in cover and cover applies" do
          @target.stub(:stance) { "Cover" }
          FS3Combat.should_receive(:stopped_by_cover?).with(2) { true }
          FS3Combat.stub(:roll_attack) { 3 }
          FS3Combat.stub(:roll_defense) { 1 }
          result = FS3Combat.determine_attack_margin(@combatant, @target, 0)
          result[:message].should eq "fs3combat.attack_hits_cover"
          result[:hit].should eq false
        end

        it "should be hit if the attacker ties" do
          FS3Combat.stub(:roll_attack) { 2 }
          FS3Combat.stub(:roll_defense) { 2 }
          result = FS3Combat.determine_attack_margin(@combatant, @target, 0)
          result[:message].should be_nil
          result[:attacker_net_successes].should eq 0
          result[:hit].should eq true
        end

        it "should be hit if the attacker wins" do
          FS3Combat.stub(:roll_attack) { 4 }
          FS3Combat.stub(:roll_defense) { 2 }
          result = FS3Combat.determine_attack_margin(@combatant, @target, 0)
          result[:message].should be_nil
          result[:attacker_net_successes].should eq 2
          result[:hit].should eq true
        end
      end
      
      describe :attack_target do
        before do
          @target = double
          @combatant = double
          @combatant.stub(:weapon) { "Knife" }
          FS3Combat.stub(:weapon_stat).with("Knife", "recoil") { 1 }
          @combatant.stub(:recoil) { 0 }
          @combatant.stub(:update)
          
          @combatant.stub(:name) { "A" }
          FS3Combat.stub(:determine_attack_margin) { { hit: true, attacker_net_successes: 2 }}
          
          FS3Combat.stub(:resolve_attack)
        end
        
        it "should return margin message if a miss" do
          FS3Combat.should_receive(:determine_attack_margin).with(@combatant, @target, 0, nil) { { hit: false, message: "dodged" }}
          FS3Combat.attack_target(@combatant, @target).should eq "dodged"
        end
        
        it "should pass along the attack mod" do
          FS3Combat.should_receive(:determine_attack_margin).with(@combatant, @target, -1, nil) { { hit: false, message: "dodged" }}
          FS3Combat.attack_target(@combatant, @target, -1)
        end
        
        it "should update recoil" do
          @combatant.stub(:recoil) { 5 }
          @combatant.should_receive(:update).with(recoil: 6)
          FS3Combat.attack_target(@combatant, @target)
        end
        
        it "should resolve the attack" do
          FS3Combat.should_receive(:resolve_attack).with("A", @target, "Knife", 2, nil)
          FS3Combat.attack_target(@combatant, @target)
        end
        
        it "should resolve the attack with a called shot and mod" do
          FS3Combat.should_receive(:resolve_attack).with("A", @target, "Knife", 2, "Head")
          FS3Combat.attack_target(@combatant, @target, 3, "Head")
        end
      end
      
      
      describe :resolve_attack do    
        
        before do
          @target = double
          FS3Combat.stub(:determine_armor) { 0 }
          FS3Combat.stub(:determine_damage) { "GRAZE" }
          FS3Combat.stub(:weapon_is_stun?) { false }
          FS3Combat.stub(:determine_hitloc) { "Chest" }
          @target.stub(:inflict_damage)
          @target.stub(:name) { "D" }
        end
            
        
        it "should determine hit location if no called shot" do
          FS3Combat.should_receive(:determine_hitloc).with(@target, 0, nil) { "Head" }
          FS3Combat.resolve_attack("A", @target, "Knife")
        end

        it "should determine hit location if called shot" do
          FS3Combat.should_receive(:determine_hitloc).with(@target, 0, "Arm") { "Hand" }
          FS3Combat.resolve_attack("A", @target, "Knife", 0, "Arm")
        end
        
        it "should return armor message if stopped by armor" do
          FS3Combat.should_receive(:determine_armor).with(@target, "Chest", "Knife", 2) { 110 }
          FS3Combat.resolve_attack("A", @target, "Knife", 2).should eq "fs3combat.attack_stopped_by_armor"
        end
        
        it "should reduce damage if armor slowed the attack" do
          FS3Combat.stub(:determine_armor) { 22 }
          FS3Combat.should_receive(:determine_damage).with(@target, "Chest", "Knife", 22) { "INCAP" }
          FS3Combat.resolve_attack("A", @target, "Knife")
        end
        
        it "should inflict damage" do
          @target.should_receive(:inflict_damage).with("GRAZE", "Knife - Chest", false)
          FS3Combat.resolve_attack("A", @target, "Knife")
        end        
        
        it "should return a hit message" do
          FS3Combat.resolve_attack("A", @target, "Knife").should eq "fs3combat.attack_hits"
        end
      end
    end
  end
end