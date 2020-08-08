module AresMUSH
  module FS3Combat
    describe Combatant do
      before do
        @combatant = double
        @char = double
        allow(@combatant).to receive(:log)
        allow(@combatant).to receive(:name) { "Trooper" }
        allow(@combatant).to receive(:character) { @char }
        stub_translate_for_testing
      end
      
      
      describe :roll_attack do
        before do
          allow(FS3Combat).to receive(:weapon_stat).with("Knife", "skill") { "Knives" }
          allow(FS3Combat).to receive(:weapon_stat).with("Knife", "accuracy") { 0 }
          allow(@combatant).to receive(:total_damage_mod) { 0 }
          allow(@combatant).to receive(:attack_stance_mod) { 0 }
          allow(@combatant).to receive(:stress) { 0 }
          allow(@combatant).to receive(:attack_mod) { 0 }
          allow(@combatant).to receive(:is_aiming?) { false }
          allow(@combatant).to receive(:weapon) { "Knife" }
          allow(@combatant).to receive(:luck)
          @target = double
          allow(@target).to receive(:mount_type) { nil }
          allow(@combatant).to receive(:mount_type) { nil }
        end
        
        it "should roll the weapon attack stat" do
          expect(@combatant).to receive(:roll_ability).with("Knives", 0)
          FS3Combat.roll_attack(@combatant, @target)
        end
        
        it "should account for aim modifier if aimed at the same target" do
          allow(@combatant).to receive(:is_aiming?) { true }
          allow(@combatant).to receive(:aim_target) { @target }
          action = double
          allow(action).to receive(:target) { @target }
          allow(@combatant).to receive(:action) { action }
          
          expect(@combatant).to receive(:roll_ability).with("Knives", 3)
          FS3Combat.roll_attack(@combatant, @target)
        end
        
        it "should not apply aim modifier if aimed at a different target" do
          allow(@combatant).to receive(:is_aiming?) { true }
          allow(@combatant).to receive(:aim_target) { @target }
          action = double
          allow(action).to receive(:target) { double }
          allow(@combatant).to receive(:action) { action }
          
          expect(@combatant).to receive(:roll_ability).with("Knives", 0)
          FS3Combat.roll_attack(@combatant, @target)
        end
        
        
        it "should account for wound modifiers" do
          allow(@combatant).to receive(:total_damage_mod) { -1 }
          expect(@combatant).to receive(:roll_ability).with("Knives", -1)
          FS3Combat.roll_attack(@combatant, @target)
        end
        
        it "should account for stance modifiers" do
          allow(@combatant).to receive(:attack_stance_mod) { 1 }
          expect(@combatant).to receive(:roll_ability).with("Knives", 1)
          FS3Combat.roll_attack(@combatant, @target)
        end
        
        it "should give a bonus when mounted vs unmounted target" do
          allow(@target).to receive(:mount_type) { nil }
          allow(@combatant).to receive(:mount_type) { "Horse" }
          allow(FS3Combat).to receive(:mount_stat).with("Horse", "mod_vs_unmounted") { 2 } 
          expect(@combatant).to receive(:roll_ability).with("Knives", 2)
          FS3Combat.roll_attack(@combatant, @target)
        end

        it "should not give a bonus when mounted vs mounted target" do
          allow(@target).to receive(:mount_type) { "Horse" }
          allow(@combatant).to receive(:mount_type) { "War Horse" }
          expect(@combatant).to receive(:roll_ability).with("Knives", 0)
          FS3Combat.roll_attack(@combatant, @target)
        end
        
        it "should give penalty when unmounted vs mounted target" do
          allow(@target).to receive(:mount_type) { "Horse" }
          allow(FS3Combat).to receive(:mount_stat).with("Horse", "mod_vs_unmounted") { 2 } 
          allow(@combatant).to receive(:mount_type) { nil }
          expect(@combatant).to receive(:roll_ability).with("Knives", -2)
          FS3Combat.roll_attack(@combatant, @target)
        end
        
        it "should account for accuracy modifiers" do
          allow(FS3Combat).to receive(:weapon_stat).with("Knife", "accuracy") { 2 }
          expect(@combatant).to receive(:roll_ability).with("Knives", 2)
          FS3Combat.roll_attack(@combatant, @target)
        end
        
        it "should account for stress modifiers" do
          allow(@combatant).to receive(:stress) { 1 }
          expect(@combatant).to receive(:roll_ability).with("Knives", -1)
          FS3Combat.roll_attack(@combatant, @target)
        end

        it "should account for luck spent on attack" do
          allow(@combatant).to receive(:luck) { "Attack" }
          expect(@combatant).to receive(:roll_ability).with("Knives", 3)
          FS3Combat.roll_attack(@combatant, @target)
        end

        it "should ignore luck spent on something else" do
          allow(@combatant).to receive(:luck) { "Defense" }
          expect(@combatant).to receive(:roll_ability).with("Knives", 0)
          FS3Combat.roll_attack(@combatant, @target)
        end
                
        it "should account for passed-in modifiers" do
          expect(@combatant).to receive(:roll_ability).with("Knives", -2)
          FS3Combat.roll_attack(@combatant, @target, -2)
        end
        
        it "should account for multiple modifiers" do
          allow(@combatant).to receive(:total_damage_mod) { -2 }
          allow(@combatant).to receive(:attack_stance_mod) { 1 }
          allow(FS3Combat).to receive(:weapon_stat).with("Knife", "accuracy") { 2 }
          expect(@combatant).to receive(:roll_ability).with("Knives", 2)
          FS3Combat.roll_attack(@combatant, @target, 1)
        end
      end
      
      describe :roll_defense do
        before do
          allow(@combatant).to receive(:total_damage_mod) { 0 }
          allow(@combatant).to receive(:defense_stance_mod) { 0 }
          allow(@combatant).to receive(:defense_mod) { 0 }
          allow(@combatant).to receive(:luck)
          allow(@combatant).to receive(:armor) { "armor" }
          allow(FS3Combat).to receive(:weapon_defense_skill) { "Reaction" }
          allow(FS3Combat).to receive(:vehicle_dodge_mod) { 0 }
          allow(FS3Combat).to receive(:armor_stat) { 0 }
        end
        
        it "should roll the weapon defense stat" do
          expect(FS3Combat).to receive(:weapon_defense_skill).with(@combatant, "Knife") { "Reaction" }
          expect(@combatant).to receive(:roll_ability).with("Reaction", 0)
          FS3Combat.roll_defense(@combatant, "Knife")
        end
        
        it "should account for wound modifiers" do
          allow(@combatant).to receive(:total_damage_mod) { -1 }
          expect(@combatant).to receive(:roll_ability).with("Reaction", -1)
          FS3Combat.roll_defense(@combatant, "Knife")
        end
        
        it "should account for stance modifiers" do
          allow(@combatant).to receive(:defense_stance_mod) { 1 }
          expect(@combatant).to receive(:roll_ability).with("Reaction", 1)
          FS3Combat.roll_defense(@combatant, "Knife")
        end
        
        it "should account for vehicle dodge modifiers" do
          expect(FS3Combat).to receive(:vehicle_dodge_mod).with(@combatant) { 1 }
          expect(@combatant).to receive(:roll_ability).with("Reaction", 1)
          FS3Combat.roll_defense(@combatant, "Knife")
        end
        
        it "should account for luck spent on defense" do
          allow(@combatant).to receive(:luck) { "Defense" }
          expect(@combatant).to receive(:roll_ability).with("Reaction", 3)
          FS3Combat.roll_defense(@combatant, "Knife")
        end

        it "should ignore luck spent on something else" do
          allow(@combatant).to receive(:luck) { "Attack" }
          expect(@combatant).to receive(:roll_ability).with("Reaction", 0)
          FS3Combat.roll_defense(@combatant, "Knife")
        end

        it "should account for armor defense stat" do
          expect(FS3Combat).to receive(:armor_stat).with("armor", "defense") { 1 }
          expect(@combatant).to receive(:roll_ability).with("Reaction", 1)
          FS3Combat.roll_defense(@combatant, "Knife")
        end
        
        it "should account for multiple modifiers" do
          allow(@combatant).to receive(:total_damage_mod) { -2 }
          allow(@combatant).to receive(:defense_stance_mod) { 1 }
          expect(@combatant).to receive(:roll_ability).with("Reaction", -1)
          FS3Combat.roll_defense(@combatant, "Knife")
        end
      end
      
      
      describe :weapon_defense_skill do
        describe "soldiers" do
          before do
            allow(FS3Combat).to receive(:weapon_stat).with("Sword", "weapon_type") { "Melee" }
            allow(FS3Combat).to receive(:weapon_stat).with("Sword", "skill") { "Swords" }
            allow(FS3Combat).to receive(:weapon_stat).with("Knife", "weapon_type") { "Melee" }
            allow(FS3Combat).to receive(:weapon_stat).with("Knife", "skill") { "Knives" }
            allow(FS3Combat).to receive(:weapon_stat).with("Pistol", "weapon_type") { "Ranged" }
            allow(FS3Combat).to receive(:weapon_stat).with("Pistol", "skill") { "Firearms" }
            allow(FS3Combat).to receive(:combatant_type_stat).with("Soldier", "defense_skill") { "Reaction" }
            allow(@combatant).to receive(:combatant_type) { "Soldier" }
            allow(@combatant).to receive(:is_in_vehicle?) { false }
          end
        
          it "should use defender melee skill for melee vs melee" do
            allow(@combatant).to receive(:weapon) { "Knife" }
            expect(FS3Combat.weapon_defense_skill(@combatant, "Sword")).to eq "Knives"
          end
        
          it "should use defender type default for melee vs ranged" do
            allow(@combatant).to receive(:weapon) { "Pistol" }
            expect(FS3Combat.weapon_defense_skill(@combatant, "Sword")).to eq "Reaction"
          end
          
          it "should use defender type default for ranged vs melee" do
            allow(@combatant).to receive(:weapon) { "Knife" }
            expect(FS3Combat.weapon_defense_skill(@combatant, "Pistol")).to eq "Reaction"
          end
          
          
          it "should use the global default if no defender type specified" do
            allow(@combatant).to receive(:combatant_type) { "NoDefense" }
            allow(FS3Combat).to receive(:combatant_type_stat).with("NoDefense", "defense_skill") { nil }
            allow(Global).to receive(:read_config).with("fs3combat", "default_defense_skill") { "Other" }
            allow(@combatant).to receive(:weapon) { "Pistol" }
            expect(FS3Combat.weapon_defense_skill(@combatant, "Sword")).to eq "Other"
          end
          
          it "should use piloting skill if in a vehicle" do
            vehicle = double
            allow(@combatant).to receive(:is_in_vehicle?) { true }
            allow(@combatant).to receive(:vehicle) { vehicle }
            allow(vehicle).to receive(:vehicle_type) { "Viper" }
            allow(FS3Combat).to receive(:vehicle_stat).with("Viper", "pilot_skill") { "Piloting" }
            expect(FS3Combat.weapon_defense_skill(@combatant, "Pistol")).to eq "Piloting"
          end
        end            
        
      end
      
      describe :hitloc_chart do
        before do 
          @vehicle = double
          allow(@combatant).to receive(:combatant_type) { "soldier" }
          allow(@combatant).to receive(:vehicle) { nil }
          @hitloc = { "areas" => "x" }
        end
          
        it "should use a soldier's hitloc chart" do
          expect(FS3Combat).to receive(:combatant_type_stat).with("soldier", "hitloc") { "human" }
          expect(FS3Combat).to receive(:hitloc_chart_for_type).with("human") { @hitloc }
          expect(FS3Combat.hitloc_chart(@combatant)).to eq @hitloc
        end
        
        it "should use a pilot's vehicle's hitloc chart if not a crew hit" do
          allow(@combatant).to receive(:vehicle) { @vehicle }
          allow(@vehicle).to receive(:hitloc_type) { "fighter" }
          expect(FS3Combat).to receive(:hitloc_chart_for_type).with("fighter") { @hitloc }
          expect(FS3Combat.hitloc_chart(@combatant)).to eq @hitloc
        end
        
        it "should use the pilot's hitloc chart if a crew hit" do
          allow(@combatant).to receive(:vehicle) { @vehicle }
          expect(FS3Combat).to receive(:combatant_type_stat).with("soldier", "hitloc") { "human" }
          expect(FS3Combat).to receive(:hitloc_chart_for_type).with("human") { @hitloc }
          expect(FS3Combat.hitloc_chart(@combatant, true)).to eq @hitloc
        end
      end
      
      describe :hitloc_areas do
        it "should extract areas from the hitloc chart" do
          expect(FS3Combat).to receive(:hitloc_chart).with(@combatant, true) { { "areas" => "x" } }
          expect(FS3Combat.hitloc_areas(@combatant, true)).to eq "x"
        end
      end
    
      describe :hitloc_severity do
        before do 
          allow(FS3Combat).to receive(:hitloc_chart).with(@combatant, false) { 
            { "vital_areas" => [ "Abdomen" ], 
              "critical_areas" => ["head"] }}
            
          allow(@combatant).to receive(:combatant_type) { "soldier"}
        end
        
        it "should determine severity for a critical area" do
          expect(FS3Combat.hitloc_severity(@combatant, "Head")).to eq "Critical"
        end

        it "should determine severity for a vital area" do
          expect(FS3Combat.hitloc_severity(@combatant, "ABDOMEN")).to eq "Vital"
        end

        it "should determine severity for a regular area" do
          expect(FS3Combat.hitloc_severity(@combatant, "Arm")).to eq "Normal"
        end
      end
      
      describe :determine_hitloc do 
        before do 
          allow(FS3Combat).to receive(:hitloc_areas) { {
            "Chest" => [ "A", "B", "C" ],
            "Head" => [ "D", "E", "F", "G" ]
          }}
        end
        
        it "should work with random lowest value" do
          expect(FS3Combat).to receive(:rand).with(3) { 0 }
          expect(FS3Combat.determine_hitloc(@combatant, 0)).to eq "A"
        end
        
        it "should work with random highest value" do
          expect(FS3Combat).to receive(:rand).with(3) { 2 }
          expect(FS3Combat.determine_hitloc(@combatant, 0)).to eq "C"
        end
        
        it "should add in successes with lowest random value" do
          expect(FS3Combat).to receive(:rand).with(3) { 0 }
          expect(FS3Combat.determine_hitloc(@combatant, 1)).to eq "B"
        end
        
        it "should add in successes with highest random value" do
          expect(FS3Combat).to receive(:rand).with(3) { 2 }
          expect(FS3Combat.determine_hitloc(@combatant, 1)).to eq "C"
        end
        
        it "should work with lowest value and negative modifier" do
          expect(FS3Combat).to receive(:rand).with(3) { 0 }
          expect(FS3Combat.determine_hitloc(@combatant, -2)).to eq "A"
        end
        
        it "should return the exact hit location if called shot and net >= 3" do
          expect(FS3Combat.determine_hitloc(@combatant, 3, "Head")).to eq "Head"
        end
        
        it "should use the called shot hitloc chart if called shot and net < 3" do
          expect(FS3Combat).to receive(:rand).with(4) { 0 }
          expect(FS3Combat.determine_hitloc(@combatant, 2, "Head")).to eq "F"
        end
      end
      
      describe :roll_initiative do
        before do
          allow(@combatant).to receive(:roll_ability) { 2 }
          allow(@combatant).to receive(:total_damage_mod) { 0 } 
          allow(@combatant).to receive(:luck)
          allow(@combatant).to receive(:action_klass) { "" }
          allow(@combatant).to receive(:weapon) { "" }
          allow(FS3Combat).to receive(:weapon_stat) { 0 }
          allow(@combatant).to receive(:initiative_mod) { 0 }
        end
        
        it "should roll the init ability" do
          expect(@combatant).to receive(:roll_ability).with("init", 0) { 3 }
          expect(FS3Combat.roll_initiative(@combatant, "init")).to eq 3
        end
        
        it "should subtract damage modifiers" do
          expect(@combatant).to receive(:roll_ability).with("init", -1) { 3 }
          allow(@combatant).to receive(:total_damage_mod) { -1 } 
          expect(FS3Combat.roll_initiative(@combatant, "init")).to eq 3
        end
        
        it "should account for luck spent on initiative" do
          allow(@combatant).to receive(:luck) {"Initiative"}
          expect(@combatant).to receive(:roll_ability).with("init", 3) { 3 }
          expect(FS3Combat.roll_initiative(@combatant, "init")).to eq 3
        end

        it "should ignore luck spent on something else" do
          allow(@combatant).to receive(:luck) {"Attack"}
          expect(@combatant).to receive(:roll_ability).with("init", 0) { 1 }
          expect(FS3Combat.roll_initiative(@combatant, "init")).to eq 1
        end
        
        it "should add in a weapon modifier" do 
          allow(@combatant).to receive(:weapon) { "Rapier" }
          expect(FS3Combat).to receive(:weapon_stat).with("Rapier", "init_mod") { 2 }
          expect(@combatant).to receive(:roll_ability).with("init", 2) { 3 }
          expect(FS3Combat.roll_initiative(@combatant, "init")).to eq 3
        end
        
        it "should default to 0 for weapon mod" do
          allow(@combatant).to receive(:weapon) { "Rapier" }
          expect(FS3Combat).to receive(:weapon_stat).with("Rapier", "init_mod") { nil }
          expect(@combatant).to receive(:roll_ability).with("init", 0) { 1 }
          expect(FS3Combat.roll_initiative(@combatant, "init")).to eq 1
        end

        it "should apply mod for subdue action" do
          allow(@combatant).to receive(:action_klass) { "AresMUSH::FS3Combat::SubdueAction" }
          expect(@combatant).to receive(:roll_ability).with("init", 3) { 4 }                  
          expect(FS3Combat.roll_initiative(@combatant, "init")).to eq 4
        end
                
        it "should apply mod for suppress action" do
          allow(@combatant).to receive(:action_klass) { "AresMUSH::FS3Combat::SuppressAction" }
          expect(@combatant).to receive(:roll_ability).with("init", 3) { 4 }                  
          expect(FS3Combat.roll_initiative(@combatant, "init")).to eq 4
        end
        
        it "should apply mod for distract action" do
          allow(@combatant).to receive(:action_klass) { "AresMUSH::FS3Combat::DistractAction" }
          expect(@combatant).to receive(:roll_ability).with("init", 3) { 4 }
          expect(FS3Combat.roll_initiative(@combatant, "init")).to eq 4
        end
        
        it "should not apply mod for regular actions" do
          allow(@combatant).to receive(:action_klass) { "AresMUSH::FS3Combat::AttackAction" }
          expect(@combatant).to receive(:roll_ability).with("init", 0) { 2 }
          expect(FS3Combat.roll_initiative(@combatant, "init")).to eq 2
        end
        
        it "should add in a gm modifier" do 
          allow(@combatant).to receive(:initiative_mod) { 2 }
          expect(@combatant).to receive(:roll_ability).with("init", 2) { 3 }
          expect(FS3Combat.roll_initiative(@combatant, "init")).to eq 3
        end
      end
      
      describe :check_ammo do
        before do
          allow(@combatant).to receive(:max_ammo) { 10 }
        end
        
        it "should return true if the weapon doesn't use ammo" do
          allow(@combatant).to receive(:max_ammo) { 0 }
          expect(FS3Combat.check_ammo(@combatant, 22)).to be true          
        end
         
        it "should return true if enough bullets" do
          allow(@combatant).to receive(:ammo) { 10 }
          expect(FS3Combat.check_ammo(@combatant, 2)).to be true
        end
        
        it "should return false if not enough bullets" do
          allow(@combatant).to receive(:ammo) { 10 }
          expect(FS3Combat.check_ammo(@combatant, 22)).to be false
        end
      end
        
      
      describe :update_ammo do
        before do
          allow(@combatant).to receive(:max_ammo) { 10 }
        end
          
        it "should not do anything if the weapon doesn't use ammo" do
          allow(@combatant).to receive(:max_ammo) { 0 }
          expect(@combatant).to_not receive(:update)
          expect(FS3Combat.update_ammo(@combatant, 1)).to be_nil
        end
      
        it "should adjust ammo by the number of bullets" do
          allow(@combatant).to receive(:ammo) { 15 }
          expect(@combatant).to receive(:update).with(ammo: 12)
          expect(FS3Combat.update_ammo(@combatant, 3)).to be_nil
        end
      
        it "should warn if out of ammo" do
          allow(@combatant).to receive(:ammo) { 4 }
          expect(@combatant).to receive(:update).with(ammo: 0)
          expect(FS3Combat.update_ammo(@combatant, 4)).to eq "fs3combat.weapon_clicks_empty"
        end
      end
    end
  end
end
