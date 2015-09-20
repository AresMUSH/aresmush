module AresMUSH
  module FS3Combat
    describe Combatant do
      before do
        @combatant = Combatant.new
        @char = double
        @combatant.stub(:character) { @char }
      end
      
      describe :roll_defense do
        before do
          @combatant.stub(:total_damage_mod) { 0 }
          @combatant.stub(:defense_stance_mod) { 0 }
          @combatant.stub(:weapon_defense_skill) { "Reaction" }
        end
        
        it "should roll the weapon defense stat" do
          @combatant.should_receive(:roll_ability).with("Reaction", 0)
          @combatant.roll_defense("Knife")
        end
        
        it "should account for wound modifiers" do
          @combatant.stub(:total_damage_mod) { 1 }
          @combatant.should_receive(:roll_ability).with("Reaction", -1)
          @combatant.roll_defense("Knife")
        end
        
        it "should account for stance modifiers" do
          @combatant.stub(:defense_stance_mod) { 1 }
          @combatant.should_receive(:roll_ability).with("Reaction", 1)
          @combatant.roll_defense("Knife")
        end
        
        it "should account for luck spent on defense" do
          @combatant.stub(:luck) { "Defense" }
          @combatant.should_receive(:roll_ability).with("Reaction", 3)
          @combatant.roll_defense("Knife")
        end

        it "should ignore luck spent on something else" do
          @combatant.stub(:luck) { "Attack" }
          @combatant.should_receive(:roll_ability).with("Reaction", 0)
          @combatant.roll_defense("Knife")
        end
        
        it "should account for multiple modifiers" do
          @combatant.stub(:total_damage_mod) { 2 }
          @combatant.stub(:defense_stance_mod) { 1 }
          @combatant.should_receive(:roll_ability).with("Reaction", -1)
          @combatant.roll_defense("Knife")
        end
      end
      
      describe :roll_attack do
        before do
          FS3Combat.stub(:weapon_stat).with("Knife", "skill") { "Knives" }
          FS3Combat.stub(:weapon_stat).with("Knife", "accuracy") { 0 }
          @combatant.stub(:total_damage_mod) { 0 }
          @combatant.stub(:attack_stance_mod) { 0 }
          @combatant.stub(:is_aiming) { false }
          @combatant.stub(:weapon) { "Knife" }
        end
        
        it "should roll the weapon attack stat" do
          @combatant.should_receive(:roll_ability).with("Knives", 0)
          @combatant.roll_attack
        end
        
        it "should account for aim modifier if aimed at the same target" do
          @combatant.stub(:is_aiming) { true }
          @combatant.stub(:aim_target) { "Bob" }
          action = double
          action.stub(:print_target_names) { "Bob" }
          @combatant.stub(:action) { action }
          
          @combatant.should_receive(:roll_ability).with("Knives", 3)
          @combatant.roll_attack
        end
        
        it "should not apply aim modifier if aimed at a different target" do
          @combatant.stub(:is_aiming) { true }
          @combatant.stub(:aim_target) { "Bob" }
          action = double
          action.stub(:print_target_names) { "Someone Else" }
          @combatant.stub(:action) { action }
          
          @combatant.should_receive(:roll_ability).with("Knives", 0)
          @combatant.roll_attack
        end
        
        
        it "should account for wound modifiers" do
          @combatant.stub(:total_damage_mod) { 1 }
          @combatant.should_receive(:roll_ability).with("Knives", -1)
          @combatant.roll_attack
        end
        
        it "should account for stance modifiers" do
          @combatant.stub(:attack_stance_mod) { 1 }
          @combatant.should_receive(:roll_ability).with("Knives", 1)
          @combatant.roll_attack
        end
        
        it "should account for accuracy modifiers" do
          FS3Combat.stub(:weapon_stat).with("Knife", "accuracy") { 2 }
          @combatant.should_receive(:roll_ability).with("Knives", 2)
          @combatant.roll_attack
        end

        it "should account for luck spent on attack" do
          @combatant.stub(:luck) { "Attack" }
          @combatant.should_receive(:roll_ability).with("Knives", 3)
          @combatant.roll_attack
        end

        it "should ignore luck spent on something else" do
          @combatant.stub(:luck) { "Defense" }
          @combatant.should_receive(:roll_ability).with("Knives", 0)
          @combatant.roll_attack
        end
                
        it "should account for passed-in modifiers" do
          @combatant.should_receive(:roll_ability).with("Knives", -2)
          @combatant.roll_attack(-2)
        end
        
        it "should account for multiple modifiers" do
          @combatant.stub(:total_damage_mod) { 2 }
          @combatant.stub(:attack_stance_mod) { 1 }
          FS3Combat.stub(:weapon_stat).with("Knife", "accuracy") { 2 }
          @combatant.should_receive(:roll_ability).with("Knives", 2)
          @combatant.roll_attack(1)
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
            @combatant.combatant_type = "Soldier"
          end
        
          it "should use defender melee skill for melee vs melee" do
            @combatant.weapon = "Knife"
            @combatant.weapon_defense_skill("Sword").should eq "Knives"
          end
        
          it "should use defender type default for melee vs ranged" do
            @combatant.weapon = "Pistol"
            @combatant.weapon_defense_skill("Sword").should eq "Reaction"
          end
        
          it "should use defender type default for ranged vs melee" do
            @combatant.weapon = "Knife"
            @combatant.weapon_defense_skill("Pistol").should eq "Reaction"
          end
        end            
        
      end
      describe :do_damage do
        it "should inflict physical damage on a PC" do
          FS3Combat.stub(:weapon_is_stun?).with("Knife") { false }
          FS3Combat.should_receive(:inflict_damage).with(@char, "M", "Knife - Arm", false) {}
          @combatant.do_damage("M", "Knife", "Arm")
        end

        it "should inflict stun damage on a PC" do
          FS3Combat.stub(:weapon_is_stun?).with("Knife") { true }
          FS3Combat.should_receive(:inflict_damage).with(@char, "M", "Knife - Arm", true) {}
          @combatant.do_damage("M", "Knife", "Arm")
        end
        
        it "should inflict damage on a NPC" do
          @combatant.stub(:character) { nil }
          @combatant.stub(:save) { } 
          @combatant.do_damage("M", "Knife", "Arm")
          @combatant.do_damage("L", "Knife", "Leg")
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
      
        describe :hitloc_severity do
          it "should determine severity" do
            FS3Combat.stub(:combatant_type_stat) { "Human" }
            FS3Combat.stub(:hitloc).with("Human") { 
              { "vital_areas" => [ "Abdomen" ], 
              "critical_areas" => ["head"] }}
              
            @combatant.hitloc_severity("Head").should eq "Critical"
            @combatant.hitloc_severity("ABDOMEN").should eq "Vital"
            @combatant.hitloc_severity("Arm").should eq "Normal"
          end
        end
        
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
          
          it "should account for cover" do
            @combatant.determine_damage("Head", "Knife", 0, 5).should eq "L"
          end
        end
        
        describe :determine_hitloc do 
          before do 
            @combatant.stub(:hitloc_chart) { ["Head", "Arm", "Leg", "Body" ]}
          end
          
          it "should work with random lowest value" do
            @combatant.should_receive(:rand).with(4) { 0 }
            @combatant.determine_hitloc(0).should eq "Head"
          end
          
          it "should work with random highest value" do
            @combatant.should_receive(:rand).with(4) { 3 }
            @combatant.determine_hitloc(0).should eq "Body"
          end
          
          it "should add in successes with lowest random value" do
            @combatant.should_receive(:rand).with(4) { 0 }
            @combatant.determine_hitloc(1).should eq "Arm"
          end
          
          it "should add in successes with highest random value" do
            @combatant.should_receive(:rand).with(4) { 3 }
            @combatant.determine_hitloc(1).should eq "Body"
          end
          
          it "should work with lowest value and negative modifier" do
            @combatant.should_receive(:rand).with(4) { 0 }
            @combatant.determine_hitloc(-2).should eq "Head"
          end
        end
        
        describe :roll_ability do
          it "should roll the specified ability for a PC" do
            FS3Skills.should_receive(:one_shot_roll).with(nil, @char, anything) do |client, char, params|
              params.ability.should eq "Firearms"
              params.modifier.should eq 3
              params.related_apt.should be_nil
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
        
        describe :roll_initiative do
          before do
            @combatant.stub(:roll_ability) { 2 }
            @combatant.stub(:total_damage_mod) { 0 } 
          end
          
          it "should roll the ability twice and add them together" do
            @combatant.should_receive(:roll_ability).with("init", 0) { 2 }
            @combatant.should_receive(:roll_ability).with("init", 0) { 3 }
            @combatant.roll_initiative("init").should eq 5
          end
          
          it "should remove damage modifiers" do
            @combatant.should_receive(:roll_ability).with("init", -1) { 2 }
            @combatant.should_receive(:roll_ability).with("init", -1) { 3 }
            @combatant.stub(:total_damage_mod) { 1 } 
            @combatant.roll_initiative("init").should eq 5
          end
          
          it "should account for luck spent on initiative" do
            @combatant.luck = "Initiative"
            @combatant.roll_initiative("init").should eq 7
          end

          it "should ignore luck spent on something else" do
            @combatant.luck = "Attack"
            @combatant.roll_initiative("init").should eq 4
          end
        end
        
      end
    end
  end