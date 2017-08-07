module AresMUSH
  module FS3Combat
    describe FS3Combat do
      before do
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :reset_for_new_turn do
        before do 
          @combatant = double
          @combatant.stub(:log)
          @combatant.stub(:name) { "Trooper" }
          @combatant.stub(:update)
          @combatant.stub(:is_aiming?) { false }
          @combatant.stub(:is_subdued?) { false }
          @combatant.stub(:freshly_damaged) { false }
          @combatant.stub(:action_klass) { nil }
          @combatant.stub(:is_ko) { false }
          FS3Combat.stub(:reset_stress)
          FS3Combat.stub(:check_for_ko)
        end
        
        it "should reset posed" do
          @combatant.should_receive(:update).with(posed: false)
          FS3Combat.reset_for_new_turn(@combatant)
        end
        
        it "should reset recoil" do
          @combatant.should_receive(:update).with(recoil: 0)
          FS3Combat.reset_for_new_turn(@combatant)
        end
        
        it "should reset fresh damage" do
          @combatant.should_receive(:update).with(freshly_damaged: false)
          FS3Combat.reset_for_new_turn(@combatant)
        end
        
        it "should reset aiming if they aren't still aiming" do 
          @combatant.stub(:is_aiming?) { true }
          @combatant.stub(:action) { AttackAction.new(@combatant, "") }
          @combatant.should_receive(:update).with(aim_target: nil)
          FS3Combat.reset_for_new_turn(@combatant)
        end

        it "should not reset aiming if they're still aiming" do 
          @combatant.stub(:is_aiming?) { true }
          @combatant.stub(:action_klass) { "AresMUSH::FS3Combat::AimAction" }
          @combatant.should_not_receive(:update).with(aim_target: nil)
          FS3Combat.reset_for_new_turn(@combatant)
        end
        
        it "should reset subdued if their attacker is no longer subduing them" do
          subduer = double
          @combatant.stub(:is_subdued?) { false }
          @combatant.should_receive(:update).with(subdued_by: nil)
          FS3Combat.reset_for_new_turn(@combatant)
        end

        it "should not reset subdued if their attacker is still subduing them" do
          subduer = double
          @combatant.stub(:is_subdued?) { true }
          @combatant.should_not_receive(:update).with(subdued_by: nil)
          FS3Combat.reset_for_new_turn(@combatant)
        end
        
        it "should lower stress" do
          FS3Combat.should_receive(:reset_stress).with(@combatant)
          FS3Combat.reset_for_new_turn(@combatant)
        end
        
        it "should remove a KO'ed NPC" do
          @combatant.stub(:is_ko) { true }
          @combatant.stub(:is_npc?) { true }
          combat = double
          @combatant.stub(:combat) { combat }
          FS3Combat.should_receive(:leave_combat).with(combat, @combatant)
          FS3Combat.reset_for_new_turn(@combatant)
        end
      end
      
      describe :reset_stress do 
        before do
          @combatant = double
          @combatant.stub(:log)
          @combatant.stub(:name) { "Bob" }
          @combatant.stub(:stress) { 0 }
          @combatant.stub(:distraction) { 0 }
          Global.stub(:read_config).with("fs3combat", "composure_skill") { "Composure" }
        end
        
        it "should reduce stress by 1 even if roll fails" do
          @combatant.stub(:stress) { 3 }
          @combatant.stub(:distraction) { 2 }
          @combatant.stub(:roll_ability).with("Composure") { 0 }
          @combatant.should_receive(:update).with(stress: 2)
          @combatant.should_receive(:update).with(distraction: 1)
          FS3Combat.reset_stress(@combatant)
        end
        
        it "should reduce stress by roll result further" do
          @combatant.stub(:stress) { 3 }
          @combatant.stub(:distraction) { 4 }
          @combatant.stub(:roll_ability).with("Composure") { 2 }
          @combatant.should_receive(:update).with(stress: 0)
          @combatant.should_receive(:update).with(distraction: 1)
          FS3Combat.reset_stress(@combatant)
        end
        
        it "should not reduce stress below 0" do
          @combatant.stub(:stress) { 1 }
          @combatant.stub(:distraction) { 1 }
          @combatant.stub(:roll_ability).with("Composure") { 2 }
          @combatant.should_receive(:update).with(stress: 0)
          @combatant.should_receive(:update).with(distraction: 0)
          FS3Combat.reset_stress(@combatant)
        end
      end
      
      describe :check_for_ko do
        before do
          @combatant = double
          @combatant.stub(:log)
          @combatant.stub(:name) { "Bob" }
          @combatant.stub(:is_ko) { false }
          @combatant.stub(:freshly_damaged) { true }
          @combatant.stub(:total_damage_mod) { -2.0 }
          @combatant.stub(:is_npc?) { false }
          @combatant.stub(:name) { "Bob" }
          @combatant.stub(:damaged_by) { [ "Bob" ] }
        end
        
        it "should do nothing if already KOd" do
          @combatant.stub(:is_ko) { true }
          FS3Combat.check_for_ko(@combatant)
        end
        
        it "should do nothing if only slightly injured" do
          @combatant.stub(:total_damage_mod) { -0.99 }
          FS3Combat.check_for_ko(@combatant)
        end
        
        it "should do nothing if not freshly damaged" do
          @combatant.stub(:freshly_damaged) { false }
          FS3Combat.check_for_ko(@combatant)
        end
        
        it "should KO the person if roll fails" do
          combat = double
          FS3Combat.should_receive(:make_ko_roll).with(@combatant) { 0 }
          @combatant.should_receive(:update).with(action_klass: nil)
          @combatant.should_receive(:update).with(action_args: nil)
          @combatant.should_receive(:update).with(is_ko: true)
          @combatant.stub(:combat) { combat }
          combat.should_receive(:emit).with("fs3combat.is_koed", nil, true)
          FS3Combat.check_for_ko(@combatant)
        end
        
        it "should auto-ko a NPC with enough damage" do
          combat = double
          @combatant.stub(:total_damage_mod) { -7.1 }
          @combatant.stub(:is_npc?) { true }
          FS3Combat.should_not_receive(:make_ko_roll)
          @combatant.should_receive(:update).with(action_klass: nil)
          @combatant.should_receive(:update).with(action_args: nil)
          @combatant.should_receive(:update).with(is_ko: true)
          @combatant.stub(:combat) { combat }
          combat.should_receive(:emit).with("fs3combat.is_koed", nil, true)
          FS3Combat.check_for_ko(@combatant)
        end
        
        it "should not auto-ko a PC with enough damage" do
          combat = double
          @combatant.stub(:total_damage_mod) { -10.1 }
          @combatant.stub(:is_npc?) { false }
          FS3Combat.should_receive(:make_ko_roll).with(@combatant) { 1 }
          FS3Combat.check_for_ko(@combatant)
        end
        
        it "should not KO the person if their roll succeeds" do
          FS3Combat.should_receive(:make_ko_roll).with(@combatant) { 1 }
          FS3Combat.check_for_ko(@combatant)
        end
      end
      
      describe :check_for_unko do
        before do
          @combatant = double
          @combatant.stub(:log)
          @combatant.stub(:is_ko) { true }
        end
        
        it "should do nothing if not KOd" do
          @combatant.stub(:is_ko) { false }
          FS3Combat.check_for_unko(@combatant)
        end
        
        it "should do nothing if KO roll fails" do
          FS3Combat.should_receive(:make_ko_roll).with(@combatant, 3) { 0 }
          FS3Combat.check_for_unko(@combatant)
        end
        
        it "should un-KO the person if their roll succeeds" do
          combat = double
          @combatant.stub(:name) { "Bob" }
          @combatant.should_receive(:update).with(is_ko: false)
          FS3Combat.should_receive(:make_ko_roll).with(@combatant, 3) { 1 }
          @combatant.stub(:combat) { combat }
          combat.should_receive(:emit).with("fs3combat.is_no_longer_koed", nil, true)
          FS3Combat.check_for_unko(@combatant)
        end
      end
      
      describe :make_ko_roll do
        before do
          @combatant = double
          @combatant.stub(:log)
          @combatant.stub(:name) { "Bob" }
          @combatant.stub(:total_damage_mod) { -2 }
          @combatant.stub(:is_npc?) { true }
          Global.stub(:read_config).with("fs3combat", "pc_knockout_bonus") { 3 }
        end
        
        it "should roll vehicle toughness if in a vehicle" do
          vehicle = double
          Global.stub(:read_config).with("fs3combat", "composure_skill") { "Composure" }
          vehicle.stub(:vehicle_type) { "Viper" }
          @combatant.stub(:is_in_vehicle?) { true }
          @combatant.stub(:vehicle) { vehicle }
          FS3Combat.stub(:vehicle_stat).with("Viper", "toughness") { 5 }
          # Total mod = +5 for vehicle, -4 for damage (-2 x 2)
          @combatant.should_receive(:roll_ability).with("Composure", 1) { 1 }
          FS3Combat.make_ko_roll(@combatant).should eq 1
        end
        
        it "should roll personal toughness if not in a vehicle" do
          @combatant.stub(:is_in_vehicle?) { false }
          Global.stub(:read_config).with("fs3combat", "composure_skill") { "Composure" }
          @combatant.should_receive(:roll_ability).with("Composure", -4) { 1 }
          FS3Combat.make_ko_roll(@combatant).should eq 1
        end
        
        it "should give PCs a bonus to knockout" do
          @combatant.stub(:is_npc?) { false }
          @combatant.stub(:is_in_vehicle?) { false }
          Global.stub(:read_config).with("fs3combat", "composure_skill") { "Composure" }
          @combatant.should_receive(:roll_ability).with("Composure", -1) { 1 }
          FS3Combat.make_ko_roll(@combatant).should eq 1
        end
      end
      
      describe :ai_action do
        before do
          @combatant = double
          @combatant.stub(:log)
          @client = double
          @combat = double
          FS3Combat.stub(:check_ammo) { true }
          @combatant.stub(:is_subdued?) { false }
        end
        
        it "should choose reload if out of ammo" do
          FS3Combat.should_receive(:check_ammo).with(@combatant, 1) { false }
          FS3Combat.should_receive(:set_action).with(@client, nil, @combat, @combatant, FS3Combat::ReloadAction, "")
          FS3Combat.ai_action(@combat, @client, @combatant)
        end
        
        it "should choose escape if subdued" do
          @combatant.stub(:is_subdued?) { true }
          FS3Combat.should_receive(:set_action).with(@client, nil, @combat, @combatant, FS3Combat::EscapeAction, "")
          FS3Combat.ai_action(@combat, @client, @combatant)
        end

        describe "attack" do
          before do
            @target1 = double
            @target2 = double
            @target2.stub(:name) { "Bob" }
            @combatant.stub(:team) { 1 }
            @combatant.stub(:weapon) { "Rifle" }
            @target1.stub(:team) { 1 }
            @target2.stub(:team) { 2 }
            FS3Combat.stub(:weapon_stat) { "" }
            FS3Combat.stub(:find_ai_target) { @target2 }
          end   
                   
          it "should attack a random target" do
            FS3Combat.should_receive(:find_ai_target).with(@combat, @combatant) { @target2 }
            FS3Combat.should_receive(:set_action).with(@client, nil, @combat, @combatant, FS3Combat::AttackAction, "Bob")
            FS3Combat.ai_action(@combat, @client, @combatant)
          end
          
          it "should do nothing if no valid target found" do
            FS3Combat.should_receive(:find_ai_target).with(@combat, @combatant) { nil }
            FS3Combat.should_receive(:set_action).with(@client, nil, @combat, @combatant, FS3Combat::PassAction, "")
            FS3Combat.ai_action(@combat, @client, @combatant)
          end
          
          it "should use the explode action for explosive weapons" do
            FS3Combat.should_receive(:weapon_stat).with("Rifle", "weapon_type") { "Explosive" }            
            FS3Combat.should_receive(:set_action).with(@client, nil, @combat, @combatant, FS3Combat::ExplodeAction, "Bob")

            FS3Combat.ai_action(@combat, @client, @combatant)
          end
          
          it "should use the suppress action for suppressive weapons" do
            FS3Combat.should_receive(:weapon_stat).with("Rifle", "weapon_type") { "Suppressive" }            
            FS3Combat.should_receive(:set_action).with(@client, nil, @combat, @combatant, FS3Combat::SuppressAction, "Bob")

            FS3Combat.ai_action(@combat, @client, @combatant)
          end
          
        end
      end
      
      describe :find_ai_target do
        before do
          @attacker = double
          @combat = double
          @target1 = double("t1")
          @target2 = double("t2")
          @target3 = double("t3")
          @target1.stub(:stance) { "Normal" }
          @target2.stub(:stance) { "Normal" }
          @target3.stub(:stance) { "Normal" }
          @attacker.stub(:team) { 1 }
          @combat.stub(:active_combatants) { [@attacker, @target1, @target2, @target3] }
          Array.any_instance.stub(:shuffle) do |instance|
            instance
          end
        end
        
        it "should find a random target on any other team if no team target specified" do
          @combat.stub(:team_targets) { {} }
          @target1.stub(:team) { 1 }
          @target2.stub(:team) { 2 }
          @target3.stub(:team) { 3 }

          target = FS3Combat.find_ai_target(@combat, @attacker)
          target.should eq @target2
        end
        
        it "should omit targets that are hidden " do
          @combat.stub(:team_targets) { {} }
          @target1.stub(:team) { 1 }
          @target2.stub(:team) { 2 }
          @target3.stub(:team) { 3 }
          @target2.stub(:stance) { "Hidden" }

          target = FS3Combat.find_ai_target(@combat, @attacker)
          target.should eq @target3
        end
        
        it "should find a random target on the specified team target teams" do
          @combat.stub(:team_targets) { { "1" => [ 3, 4 ] } }
          @target1.stub(:team) { 1 }
          @target2.stub(:team) { 2 }
          @target3.stub(:team) { 3 }

          target = FS3Combat.find_ai_target(@combat, @attacker)
          target.should eq @target3
        end
        
        it "should return nil if no valid targets found" do
          @combat.stub(:team_targets) { { "1" => [ 4 ] } }
          
          @target1.stub(:team) { 1 }
          @target2.stub(:team) { 2 }
          @target3.stub(:team) { 3 }

          target = FS3Combat.find_ai_target(@combat, @attacker)
          target.should eq nil
        end
      end
      
      describe :stopped_by_cover? do
        before do 
          @combatant = double
          @combatant.stub(:log)
        end
        
        it "should bypass cover if enough successes on attack roll" do
          FS3Combat.stub(:rand) { 0 }
          FS3Combat.stopped_by_cover?(3, @combatant).should be false
        end
        
        it "should have 50% cover for a marginal attack roll" do
          FS3Combat.stub(:rand) { 51 }
          FS3Combat.stopped_by_cover?(0, @combatant).should be false
          FS3Combat.stopped_by_cover?(1, @combatant).should be false
          FS3Combat.stub(:rand) { 49 }
          FS3Combat.stopped_by_cover?(0, @combatant).should be true
          FS3Combat.stopped_by_cover?(1, @combatant).should be true
        end
        
        it "should have 25% cover for a decent attack roll" do

          FS3Combat.stub(:rand) { 26 }
          FS3Combat.stopped_by_cover?(2, @combatant).should be false
          FS3Combat.stub(:rand) { 24 }
          FS3Combat.stopped_by_cover?(2, @combatant).should be true
        end
      end
      
      describe :determine_damage do
        before do 
          @combatant = double
          @combatant.stub(:log)
          @combatant.stub(:damage_lethality_mod) { 0 }
          @combatant.stub(:is_npc?) { false }
          FS3Combat.stub(:hitloc_severity).with(@combatant, "Chest", false) { "Vital" }
          FS3Combat.stub(:weapon_stat).with("Knife", "lethality") { 0 }
          FS3Combat.stub(:rand) { 0 }
          Global.stub(:read_config).with("fs3combat", "damage_table") { { "GRAZE" => 20, "FLESH" => 60, "IMPAIR" => 100 } }
          
        end
  
        describe "random damage" do
          it "should roll a graze" do
            FS3Combat.stub(:rand) { 19 }
            FS3Combat.determine_damage(@combatant, "Chest", "Knife").should eq "GRAZE"
          end
          
          it "should roll a flesh wound" do
            FS3Combat.stub(:rand) { 59 }
            FS3Combat.determine_damage(@combatant, "Chest", "Knife").should eq "FLESH"
          end
          
          it "should roll an impairing wound" do
            FS3Combat.stub(:rand) { 80 }
            FS3Combat.determine_damage(@combatant, "Chest", "Knife").should eq "IMPAIR"
          end
          
          it "should roll an incap wound" do
            FS3Combat.stub(:rand) { 101 }
            FS3Combat.determine_damage(@combatant, "Chest", "Knife").should eq "INCAP"
          end
        end
  
        it "should pass along a crew hit" do
          FS3Combat.stub(:hitloc_severity).with(@combatant, "Chest", true) { "Normal" }
          FS3Combat.determine_damage(@combatant, "Chest", "Knife", 0, true).should eq "GRAZE"
        end
        
        it "should account for lethality" do
          FS3Combat.stub(:weapon_stat).with("Knife", "lethality") { 40 }
          FS3Combat.determine_damage(@combatant, "Chest", "Knife").should eq "FLESH"
        end

        it "should account for hitloc severity for non-vital" do
          FS3Combat.stub(:rand) { 29 }
          FS3Combat.stub(:hitloc_severity).with(@combatant, "Chest", false) { "Normal" }
          FS3Combat.determine_damage(@combatant, "Chest", "Knife").should eq "GRAZE"
        end

        it "should account for hitloc severity for critical" do
          FS3Combat.stub(:hitloc_severity).with(@combatant, "Chest", false) { "Critical" }
          FS3Combat.stub(:rand) { 80 }
          FS3Combat.stub(:weapon_stat).with("Knife", "lethality") { 0 }
          FS3Combat.determine_damage(@combatant, "Chest", "Knife").should eq "INCAP"
        end
  
        it "should account for armor" do
          FS3Combat.stub(:rand) { 24 }
          FS3Combat.determine_damage(@combatant, "Chest", "Knife", -5).should eq "GRAZE"
        end
      end
      
      describe :determine_armor do
        before do 
          @combatant = double
          @combatant.stub(:log)
          @combatant.stub(:vehicle) { nil }
          @combatant.stub(:armor) { "Tactical" }
          FS3Skills.stub(:one_shot_die_roll) { { successes: 0 } }
          FS3Combat.stub(:weapon_stat) { 5 }
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
        
        it "should bypass armor if weapon wins by enough" do
          FS3Combat.stub(:rand).with(8) { 6 }
          FS3Combat.stub(:weapon_stat).with("Rifle", "penetration") { 5 }
          FS3Combat.stub(:armor_stat).with("Tactical", "protection") { { "Head" => 3 } }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 0).should eq 0
        end
        
        it "should provide minimum armor xxx" do
          FS3Combat.stub(:rand).with(8) { 4 }
          FS3Combat.stub(:rand).with(25) { 24 }
          FS3Combat.stub(:weapon_stat).with("Rifle", "penetration") { 5 }
          FS3Combat.stub(:armor_stat).with("Tactical", "protection") { { "Head" => 3 } }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 0).should eq 24
        end

        it "should provide some armor" do
          FS3Combat.stub(:rand).with(8) { 2 }
          FS3Combat.stub(:weapon_stat).with("Rifle", "penetration") { 5 }
          FS3Combat.stub(:armor_stat).with("Tactical", "protection") { { "Head" => 3 } }
          FS3Combat.stub(:rand).with(25) { 19 }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 0).should eq 44
        end

        it "should provide extra armor" do
          FS3Combat.stub(:rand).with(8) { 0 }
          FS3Combat.stub(:weapon_stat).with("Rifle", "penetration") { 5 }
          FS3Combat.stub(:armor_stat).with("Tactical", "protection") { { "Head" => 3 } }
          FS3Combat.stub(:rand).with(50) { 15 }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 0).should eq 65
        end

        it "should stop attack if armor wins by enough" do
          FS3Combat.stub(:rand).with(8) { 1 }
          FS3Combat.stub(:weapon_stat).with("Rifle", "penetration") { 5 }
          FS3Combat.stub(:armor_stat).with("Tactical", "protection") { { "Head" => 6 } }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 0).should eq 100
        end

        it "should add in attacker successes for to pen roll" do
          FS3Combat.stub(:rand).with(8) { 8 }
          FS3Combat.stub(:weapon_stat).with("Rifle", "penetration") { 3 }
          FS3Combat.stub(:armor_stat).with("Tactical", "protection") { { "Head" => 5 } }
          FS3Combat.determine_armor(@combatant, "Head", "Rifle", 2).should eq 0
        end        
      end
      
      describe :determine_attack_margin do
        before do
          @combatant = double
          @combatant.stub(:log)
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
          FS3Combat.should_receive(:stopped_by_cover?).with(2, @combatant) { true }
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
          @combatant.stub(:log)
          @combatant.stub(:weapon) { "Knife" }
          FS3Combat.stub(:weapon_stat).with("Knife", "recoil") { 1 }
          @combatant.stub(:recoil) { 0 }
          @combatant.stub(:update)
          @target.stub(:riding_in) { nil }
          @combatant.stub(:name) { "A" }
          FS3Combat.stub(:determine_attack_margin) { { hit: true, attacker_net_successes: 2 }}
          
          FS3Combat.stub(:resolve_attack)
        end
        
        it "should return margin message if a miss" do
          FS3Combat.should_receive(:determine_attack_margin).with(@combatant, @target, 0, nil) { { hit: false, message: "dodged" }}
          FS3Combat.attack_target(@combatant, @target).should eq ["dodged"]
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
          FS3Combat.should_receive(:resolve_attack).with(@combatant, "A", @target, "Knife", 2, nil, false)
          FS3Combat.attack_target(@combatant, @target)
        end
        
        it "should resolve the attack with a called shot and mod" do
          FS3Combat.should_receive(:resolve_attack).with(@combatant, "A", @target, "Knife", 2, "Head", false)
          FS3Combat.attack_target(@combatant, @target, 3, "Head")
        end
        
        it "should resolve the attack with a crew hit" do
          FS3Combat.should_receive(:resolve_attack).with(@combatant, "A", @target, "Knife", 2, nil, true)
          FS3Combat.attack_target(@combatant, @target, 3, nil, true)
        end
        
        it "should attack the pilot when the passenger is targeted" do
          pilot = double
          vehicle = double
          @target.stub(:riding_in) { vehicle }
          vehicle.stub(:pilot) { pilot }
          FS3Combat.should_receive(:resolve_attack).with(@combatant, "A", pilot, "Knife", 2, nil, false)
          FS3Combat.attack_target(@combatant, @target)
        end

        it "should not attack a non-existent pilot if a passenger is targeted" do
          pilot = double
          vehicle = double
          @target.stub(:riding_in) { vehicle }
          vehicle.stub(:pilot) { nil }
          FS3Combat.should_receive(:resolve_attack).with(@combatant, "A", @target, "Knife", 2, nil, false)
          FS3Combat.attack_target(@combatant, @target)
        end
      end
      
      
      describe :resolve_attack do    
        
        before do
          @target = double
          @combatant = double
          FS3Combat.stub(:determine_armor) { 0 }
          FS3Combat.stub(:determine_damage) { "GRAZE" }
          FS3Combat.stub(:weapon_is_stun?) { false }
          FS3Combat.stub(:determine_hitloc) { "Chest" }
          FS3Combat.stub(:resolve_possible_crew_hit) { [] }
          @target.stub(:log)
          @target.stub(:inflict_damage)
          @target.stub(:name) { "D" }
          @target.stub(:add_stress)
          @target.stub(:update).with(freshly_damaged: true)
          @target.stub(:damaged_by) { [] }
          @target.stub(:luck) { "" }
          @target.stub(:update).with(damaged_by: [ "A" ]) {}
          @combatant.stub(:luck) { "" }
        end
            
        
        it "should determine hit location if no called shot" do
          FS3Combat.should_receive(:determine_hitloc).with(@target, 0, nil, false) { "Head" }
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife")
        end

        it "should determine hit location if called shot" do
          FS3Combat.should_receive(:determine_hitloc).with(@target, 0, "Arm", false) { "Hand" }
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife", 0, "Arm")
        end
        
        it "should return armor message if stopped by armor" do
          FS3Combat.should_receive(:determine_armor).with(@target, "Chest", "Knife", 2) { 110 }
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife", 2).should eq ["fs3combat.attack_stopped_by_armor"]
        end
        
        it "should reduce damage if armor slowed the attack" do
          FS3Combat.stub(:determine_armor) { 22 }
          FS3Combat.should_receive(:determine_damage).with(@target, "Chest", "Knife", -22, false) { "INCAP" }
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife")
        end
        
        it "should update damaged by xxx" do 
          @target.stub(:damaged_by) { [ "X" ] }
          @target.should_receive(:update).with(damaged_by: [ "X", "A" ])
          FS3Combat.should_receive(:determine_damage).with(@target, "Chest", "Knife", 0, false) { "INCAP" }
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife")
        end
        
        it "should add success to damage" do
          FS3Combat.should_receive(:determine_damage).with(@target, "Chest", "Knife", 15, false) { "INCAP" }
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife", 4)
        end
        
        it "should add luck to damage if luck spent on attack" do
          FS3Combat.stub(:determine_armor) { 22 }
          @combatant.stub(:luck) { "Attack" }
          FS3Combat.should_receive(:determine_damage).with(@target, "Chest", "Knife", 8, false) { "INCAP" }
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife")
        end
        
        it "should subtract luck from damage if luck spent on defense" do
          FS3Combat.stub(:determine_armor) { 22 }
          @target.stub(:luck) { "Defense" }
          FS3Combat.should_receive(:determine_damage).with(@target, "Chest", "Knife", -52, false) { "INCAP" }
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife")
        end
        
        it "should inflict damage" do
          @target.should_receive(:inflict_damage).with("GRAZE", "Knife - Chest", false, false)
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife")
        end      
        
        it "should mark as freshly damaged" do
          FS3Combat.stub(:determine_damage) { "FLESH" }
          @target.should_receive(:update).with(freshly_damaged: true)
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife")
        end
        
        it "should not mark as freshly damaged for a graze wound" do
          FS3Combat.stub(:determine_damage) { "GRAZE" }
          @target.should_not_receive(:update).with(freshly_damaged: true)
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife")
        end

        it "should return a hit message" do
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife").should eq ["fs3combat.attack_hits"]
        end
        
        it "should add a stress point" do
          @target.should_receive(:add_stress).with(1)
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife").should eq ["fs3combat.attack_hits"]
        end
        
        it "should pass along a crew hit" do
          @target.should_receive(:inflict_damage).with("GRAZE", "Knife - Chest", false, true)
          FS3Combat.resolve_attack(@combatant, "A", @target, "Knife", 0, nil, true).should eq ["fs3combat.attack_hits"]
        end
      end
      
      describe :resolve_possible_crew_hit do
        before do
          @target = double
          @target.stub(:is_in_vehicle?) { true }
          @target.stub(:log)
          @vehicle = double
          FS3Combat.stub(:hitloc_chart).with(@target) { { "crew_areas" => ["Cockpit"] } }
          
          # By seeding the kernel random number generator, the first two shrapnel rolls
          # will always be 2, 1.
          Kernel.srand 5
          
        end
        
        it "should return nothing if not in vehicle" do
          @target.stub(:is_in_vehicle?) { false }
          FS3Combat.resolve_possible_crew_hit(@target, "Body", "GRAZE").should eq []
        end
        
        it "should not do damage if not a crew hitloc xxx" do
          @target.stub(:vehicle) { @vehicle}
          FS3Combat.resolve_possible_crew_hit(@target, "Body", "GRAZE").should eq []
        end
        
        it "should inflict shrapnel to each passenger" do
          p1 = double
          p2 = double
          p1.stub(:name) { "a" }
          p2.stub(:name) { "b" }
          
          
          @target.stub(:vehicle) { @vehicle }
          @vehicle.stub(:passengers) { [p1] }
          @vehicle.stub(:pilot) { p2 }
          FS3Combat.should_receive(:resolve_attack).with(nil, t('fs3combat.crew_hit'), p1, "Shrapnel", 0, nil, true) { ["a1"]}
          FS3Combat.should_receive(:resolve_attack).with(nil, t('fs3combat.crew_hit'), p1, "Shrapnel", 0, nil, true) { ["a2"]}
          FS3Combat.should_receive(:resolve_attack).with(nil, t('fs3combat.crew_hit'), p2, "Shrapnel", 0, nil, true) { ["a3"]}

          FS3Combat.resolve_possible_crew_hit(@target, "Cockpit", "IMPAIR").should eq ["a1", "a2", "a3"]
        end
        
      end
    end
  end
end