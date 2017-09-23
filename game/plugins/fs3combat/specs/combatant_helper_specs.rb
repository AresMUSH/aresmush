module AresMUSH
  module FS3Combat
    describe Combatant do
      before do
        @combatant = double
        @char = double
        @combatant.stub(:log)
        @combatant.stub(:name) { "Trooper" }
        @combatant.stub(:character) { @char }
        SpecHelpers.stub_translate_for_testing
      end
      
      
      describe :roll_attack do
        before do
          FS3Combat.stub(:weapon_stat).with("Knife", "skill") { "Knives" }
          FS3Combat.stub(:weapon_stat).with("Knife", "accuracy") { 0 }
          @combatant.stub(:total_damage_mod) { 0 }
          @combatant.stub(:attack_stance_mod) { 0 }
          @combatant.stub(:stress) { 0 }
          @combatant.stub(:distraction) { 0 }
          @combatant.stub(:attack_mod) { 0 }
          @combatant.stub(:is_aiming?) { false }
          @combatant.stub(:weapon) { "Knife" }
          @combatant.stub(:luck)
        end
        
        it "should roll the weapon attack stat" do
          @combatant.should_receive(:roll_ability).with("Knives", 0)
          FS3Combat.roll_attack(@combatant)
        end
        
        it "should account for aim modifier if aimed at the same target" do
          target = double
          @combatant.stub(:is_aiming?) { true }
          @combatant.stub(:aim_target) { target }
          action = double
          action.stub(:target) { target }
          @combatant.stub(:action) { action }
          
          @combatant.should_receive(:roll_ability).with("Knives", 3)
          FS3Combat.roll_attack(@combatant)
        end
        
        it "should not apply aim modifier if aimed at a different target" do
          target = double
          @combatant.stub(:is_aiming?) { true }
          @combatant.stub(:aim_target) { target }
          action = double
          action.stub(:target) { double }
          @combatant.stub(:action) { action }
          
          @combatant.should_receive(:roll_ability).with("Knives", 0)
          FS3Combat.roll_attack(@combatant)
        end
        
        
        it "should account for wound modifiers" do
          @combatant.stub(:total_damage_mod) { -1 }
          @combatant.should_receive(:roll_ability).with("Knives", -1)
          FS3Combat.roll_attack(@combatant)
        end
        
        it "should account for distract modifiers" do
          @combatant.stub(:distraction) { 2 }
          @combatant.should_receive(:roll_ability).with("Knives", -2)
          FS3Combat.roll_attack(@combatant)
        end
        
        it "should account for stance modifiers" do
          @combatant.stub(:attack_stance_mod) { 1 }
          @combatant.should_receive(:roll_ability).with("Knives", 1)
          FS3Combat.roll_attack(@combatant)
        end
        
        it "should account for accuracy modifiers" do
          FS3Combat.stub(:weapon_stat).with("Knife", "accuracy") { 2 }
          @combatant.should_receive(:roll_ability).with("Knives", 2)
          FS3Combat.roll_attack(@combatant)
        end
        
        it "should account for stress modifiers" do
          @combatant.stub(:stress) { 1 }
          @combatant.should_receive(:roll_ability).with("Knives", -1)
          FS3Combat.roll_attack(@combatant)
        end

        it "should account for luck spent on attack" do
          @combatant.stub(:luck) { "Attack" }
          @combatant.should_receive(:roll_ability).with("Knives", 3)
          FS3Combat.roll_attack(@combatant)
        end

        it "should ignore luck spent on something else" do
          @combatant.stub(:luck) { "Defense" }
          @combatant.should_receive(:roll_ability).with("Knives", 0)
          FS3Combat.roll_attack(@combatant)
        end
                
        it "should account for passed-in modifiers" do
          @combatant.should_receive(:roll_ability).with("Knives", -2)
          FS3Combat.roll_attack(@combatant, -2)
        end
        
        it "should account for multiple modifiers" do
          @combatant.stub(:total_damage_mod) { -2 }
          @combatant.stub(:attack_stance_mod) { 1 }
          FS3Combat.stub(:weapon_stat).with("Knife", "accuracy") { 2 }
          @combatant.should_receive(:roll_ability).with("Knives", 2)
          FS3Combat.roll_attack(@combatant, 1)
        end
      end
      
      describe :roll_defense do
        before do
          @combatant.stub(:total_damage_mod) { 0 }
          @combatant.stub(:defense_stance_mod) { 0 }
          @combatant.stub(:defense_mod) { 0 }
          @combatant.stub(:distraction) { 0 }
          @combatant.stub(:luck)
          FS3Combat.stub(:weapon_defense_skill) { "Reaction" }
          FS3Combat.stub(:vehicle_dodge_mod) { 0 }
        end
        
        it "should roll the weapon defense stat" do
          FS3Combat.should_receive(:weapon_defense_skill).with(@combatant, "Knife") { "Reaction" }
          @combatant.should_receive(:roll_ability).with("Reaction", 0)
          FS3Combat.roll_defense(@combatant, "Knife")
        end
        
        it "should account for wound modifiers" do
          @combatant.stub(:total_damage_mod) { -1 }
          @combatant.should_receive(:roll_ability).with("Reaction", -1)
          FS3Combat.roll_defense(@combatant, "Knife")
        end
        
        it "should account for distract modifiers" do
          @combatant.stub(:distraction) { 2 }
          @combatant.should_receive(:roll_ability).with("Reaction", -2)
          FS3Combat.roll_defense(@combatant, "Knife")
        end
                
        it "should account for stance modifiers" do
          @combatant.stub(:defense_stance_mod) { 1 }
          @combatant.should_receive(:roll_ability).with("Reaction", 1)
          FS3Combat.roll_defense(@combatant, "Knife")
        end
        
        it "should account for vehicle dodge modifiers" do
          FS3Combat.should_receive(:vehicle_dodge_mod).with(@combatant) { 1 }
          @combatant.should_receive(:roll_ability).with("Reaction", 1)
          FS3Combat.roll_defense(@combatant, "Knife")
        end
        
        it "should account for luck spent on defense" do
          @combatant.stub(:luck) { "Defense" }
          @combatant.should_receive(:roll_ability).with("Reaction", 3)
          FS3Combat.roll_defense(@combatant, "Knife")
        end

        it "should ignore luck spent on something else" do
          @combatant.stub(:luck) { "Attack" }
          @combatant.should_receive(:roll_ability).with("Reaction", 0)
          FS3Combat.roll_defense(@combatant, "Knife")
        end
        
        it "should account for multiple modifiers" do
          @combatant.stub(:total_damage_mod) { -2 }
          @combatant.stub(:defense_stance_mod) { 1 }
          @combatant.should_receive(:roll_ability).with("Reaction", -1)
          FS3Combat.roll_defense(@combatant, "Knife")
        end
      end
      
      
      describe :weapon_defense_skill do
        describe "soldiers" do
          before do
            FS3Combat.stub(:weapon_stat).with("Sword", "weapon_type") { "Melee" }
            FS3Combat.stub(:weapon_stat).with("Sword", "skill") { "Swords" }
            FS3Combat.stub(:weapon_stat).with("Knife", "weapon_type") { "Melee" }
            FS3Combat.stub(:weapon_stat).with("Knife", "skill") { "Knives" }
            FS3Combat.stub(:weapon_stat).with("Pistol", "weapon_type") { "Ranged" }
            FS3Combat.stub(:weapon_stat).with("Pistol", "skill") { "Firearms" }
            FS3Combat.stub(:combatant_type_stat).with("Soldier", "defense_skill") { "Reaction" }
            @combatant.stub(:combatant_type) { "Soldier" }
            @combatant.stub(:is_in_vehicle?) { false }
          end
        
          it "should use defender melee skill for melee vs melee" do
            @combatant.stub(:weapon) { "Knife" }
            FS3Combat.weapon_defense_skill(@combatant, "Sword").should eq "Knives"
          end
        
          it "should use defender type default for melee vs ranged" do
            @combatant.stub(:weapon) { "Pistol" }
            FS3Combat.weapon_defense_skill(@combatant, "Sword").should eq "Reaction"
          end
          
          it "should use defender type default for ranged vs melee" do
            @combatant.stub(:weapon) { "Knife" }
            FS3Combat.weapon_defense_skill(@combatant, "Pistol").should eq "Reaction"
          end
          
          
          it "should use the global default if no defender type specified" do
            @combatant.stub(:combatant_type) { "NoDefense" }
            FS3Combat.stub(:combatant_type_stat).with("NoDefense", "defense_skill") { nil }
            Global.stub(:read_config).with("fs3combat", "default_defense_skill") { "Other" }
            @combatant.stub(:weapon) { "Pistol" }
            FS3Combat.weapon_defense_skill(@combatant, "Sword").should eq "Other"
          end
          
          it "should use piloting skill if in a vehicle" do
            vehicle = double
            @combatant.stub(:is_in_vehicle?) { true }
            @combatant.stub(:vehicle) { vehicle }
            vehicle.stub(:vehicle_type) { "Viper" }
            FS3Combat.stub(:vehicle_stat).with("Viper", "pilot_skill") { "Piloting" }
            FS3Combat.weapon_defense_skill(@combatant, "Pistol").should eq "Piloting"
          end
        end            
        
      end
      
      describe :hitloc_chart do
        before do 
          @vehicle = double
          @combatant.stub(:combatant_type) { "soldier" }
          @combatant.stub(:vehicle) { nil }
          @hitloc = { "areas" => "x" }
        end
          
        it "should use a soldier's hitloc chart" do
          FS3Combat.should_receive(:combatant_type_stat).with("soldier", "hitloc") { "human" }
          FS3Combat.should_receive(:hitloc_chart_for_type).with("human") { @hitloc }
          FS3Combat.hitloc_chart(@combatant).should eq @hitloc
        end
        
        it "should use a pilot's vehicle's hitloc chart if not a crew hit" do
          @combatant.stub(:vehicle) { @vehicle }
          @vehicle.stub(:hitloc_type) { "fighter" }
          FS3Combat.should_receive(:hitloc_chart_for_type).with("fighter") { @hitloc }
          FS3Combat.hitloc_chart(@combatant).should eq @hitloc
        end
        
        it "should use the pilot's hitloc chart if a crew hit" do
          @combatant.stub(:vehicle) { @vehicle }
          FS3Combat.should_receive(:combatant_type_stat).with("soldier", "hitloc") { "human" }
          FS3Combat.should_receive(:hitloc_chart_for_type).with("human") { @hitloc }
          FS3Combat.hitloc_chart(@combatant, true).should eq @hitloc
        end
      end
      
      describe :hitloc_areas do
        it "should extract areas from the hitloc chart" do
          FS3Combat.should_receive(:hitloc_chart).with(@combatant, true) { { "areas" => "x" } }
          FS3Combat.hitloc_areas(@combatant, true).should eq "x"
        end
      end
    
      describe :hitloc_severity do
        before do 
          FS3Combat.stub(:hitloc_chart).with(@combatant, false) { 
            { "vital_areas" => [ "Abdomen" ], 
              "critical_areas" => ["head"] }}
            
          @combatant.stub(:combatant_type) { "soldier"}
        end
        
        it "should determine severity for a critical area" do
          FS3Combat.hitloc_severity(@combatant, "Head").should eq "Critical"
        end

        it "should determine severity for a vital area" do
          FS3Combat.hitloc_severity(@combatant, "ABDOMEN").should eq "Vital"
        end

        it "should determine severity for a regular area" do
          FS3Combat.hitloc_severity(@combatant, "Arm").should eq "Normal"
        end
      end
      
      describe :determine_hitloc do 
        before do 
          FS3Combat.stub(:hitloc_areas) { {
            "Chest" => [ "A", "B", "C" ],
            "Head" => [ "D", "E", "F", "G" ]
          }}
        end
        
        it "should work with random lowest value" do
          FS3Combat.should_receive(:rand).with(3) { 0 }
          FS3Combat.determine_hitloc(@combatant, 0).should eq "A"
        end
        
        it "should work with random highest value" do
          FS3Combat.should_receive(:rand).with(3) { 2 }
          FS3Combat.determine_hitloc(@combatant, 0).should eq "C"
        end
        
        it "should add in successes with lowest random value" do
          FS3Combat.should_receive(:rand).with(3) { 0 }
          FS3Combat.determine_hitloc(@combatant, 1).should eq "B"
        end
        
        it "should add in successes with highest random value" do
          FS3Combat.should_receive(:rand).with(3) { 2 }
          FS3Combat.determine_hitloc(@combatant, 1).should eq "C"
        end
        
        it "should work with lowest value and negative modifier" do
          FS3Combat.should_receive(:rand).with(3) { 0 }
          FS3Combat.determine_hitloc(@combatant, -2).should eq "A"
        end
        
        it "should return the exact hit location if called shot and net >= 3" do
          FS3Combat.determine_hitloc(@combatant, 3, "Head").should eq "Head"
        end
        
        it "should use the called shot hitloc chart if called shot and net < 3" do
          FS3Combat.should_receive(:rand).with(4) { 0 }
          FS3Combat.determine_hitloc(@combatant, 2, "Head").should eq "F"
        end
      end
      
      describe :roll_initiative do
        before do
          @combatant.stub(:roll_ability) { 2 }
          @combatant.stub(:total_damage_mod) { 0 } 
          @combatant.stub(:luck)
          @combatant.stub(:action_klass) { "" }
          @combatant.stub(:weapon) { "" }
          FS3Combat.stub(:weapon_stat) { 0 }
        end
        
        it "should roll the init ability" do
          @combatant.should_receive(:roll_ability).with("init", 0) { 3 }
          FS3Combat.roll_initiative(@combatant, "init").should eq 3
        end
        
        it "should subtract damage modifiers" do
          @combatant.should_receive(:roll_ability).with("init", -1) { 3 }
          @combatant.stub(:total_damage_mod) { -1 } 
          FS3Combat.roll_initiative(@combatant, "init").should eq 3
        end
        
        it "should account for luck spent on initiative" do
          @combatant.stub(:luck) {"Initiative"}
          @combatant.should_receive(:roll_ability).with("init", 3) { 3 }
          FS3Combat.roll_initiative(@combatant, "init").should eq 3
        end

        it "should ignore luck spent on something else" do
          @combatant.stub(:luck) {"Attack"}
          @combatant.should_receive(:roll_ability).with("init", 0) { 1 }
          FS3Combat.roll_initiative(@combatant, "init").should eq 1
        end
        
        it "should add in a weapon modifier" do 
          @combatant.stub(:weapon) { "Rapier" }
          FS3Combat.should_receive(:weapon_stat).with("Rapier", "init_mod") { 2 }
          @combatant.should_receive(:roll_ability).with("init", 2) { 3 }
          FS3Combat.roll_initiative(@combatant, "init").should eq 3
        end
        
        it "should default to 0 for weapon mod" do
          @combatant.stub(:weapon) { "Rapier" }
          FS3Combat.should_receive(:weapon_stat).with("Rapier", "init_mod") { nil }
          @combatant.should_receive(:roll_ability).with("init", 0) { 1 }
          FS3Combat.roll_initiative(@combatant, "init").should eq 1
        end

        it "should apply mod for subdue action" do
          @combatant.stub(:action_klass) { "AresMUSH::FS3Combat::SubdueAction" }
          @combatant.should_receive(:roll_ability).with("init", 3) { 4 }                  
          FS3Combat.roll_initiative(@combatant, "init").should eq 4
        end
                
        it "should apply mod for suppress action" do
          @combatant.stub(:action_klass) { "AresMUSH::FS3Combat::SuppressAction" }
          @combatant.should_receive(:roll_ability).with("init", 3) { 4 }                  
          FS3Combat.roll_initiative(@combatant, "init").should eq 4
        end
        
        it "should apply mod for distract action" do
          @combatant.stub(:action_klass) { "AresMUSH::FS3Combat::DistractAction" }
          @combatant.should_receive(:roll_ability).with("init", 3) { 4 }
          FS3Combat.roll_initiative(@combatant, "init").should eq 4
        end
        
        it "should not apply mod for regular actions" do
          @combatant.stub(:action_klass) { "AresMUSH::FS3Combat::AttackAction" }
          @combatant.should_receive(:roll_ability).with("init", 0) { 2 }
          FS3Combat.roll_initiative(@combatant, "init").should eq 2
        end
      end
      
      describe :check_ammo do
        before do
          @combatant.stub(:max_ammo) { 10 }
        end
        
        it "should return true if the weapon doesn't use ammo" do
          @combatant.stub(:max_ammo) { 0 }
          FS3Combat.check_ammo(@combatant, 22).should be true          
        end
         
        it "should return true if enough bullets" do
          @combatant.stub(:ammo) { 10 }
          FS3Combat.check_ammo(@combatant, 2).should be true
        end
        
        it "should return false if not enough bullets" do
          @combatant.stub(:ammo) { 10 }
          FS3Combat.check_ammo(@combatant, 22).should be false
        end
      end
        
      
      describe :update_ammo do
        before do
          @combatant.stub(:max_ammo) { 10 }
        end
          
        it "should not do anything if the weapon doesn't use ammo" do
          @combatant.stub(:max_ammo) { 0 }
          @combatant.should_not_receive(:update)
          FS3Combat.update_ammo(@combatant, 1).should be_nil
        end
      
        it "should adjust ammo by the number of bullets" do
          @combatant.stub(:ammo) { 15 }
          @combatant.should_receive(:update).with(ammo: 12)
          FS3Combat.update_ammo(@combatant, 3).should be_nil
        end
      
        it "should warn if out of ammo" do
          @combatant.stub(:ammo) { 4 }
          @combatant.should_receive(:update).with(ammo: 0)
          FS3Combat.update_ammo(@combatant, 4).should eq "fs3combat.weapon_clicks_empty"
        end
      end
    end
  end
end
