module AresMUSH
  module FS3Combat
    describe Combatant do
      before do
        @combatant = Combatant.new
        @char = double
        @combatant.stub(:character) { @char }
        SpecHelpers.stub_translate_for_testing
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
        before do
          @combat = double
          @combatant.stub(:combat) { @combat }
          @combat.stub(:is_real) { true }
        end
        
        it "should inflict physical damage on a PC" do
          FS3Combat.stub(:weapon_is_stun?).with("Knife") { false }
          FS3Combat.should_receive(:inflict_damage).with(@char, "M", "Knife - Arm", false, false) {}
          @combatant.do_damage("M", "Knife", "Arm")
        end

        it "should inflict stun damage on a PC" do
          FS3Combat.stub(:weapon_is_stun?).with("Knife") { true }
          FS3Combat.should_receive(:inflict_damage).with(@char, "M", "Knife - Arm", true, false) {}
          @combatant.do_damage("M", "Knife", "Arm")
        end
        
        it "should inflict mock damage on a PC" do
          @combat.stub(:is_real) { false }
          FS3Combat.stub(:weapon_is_stun?).with("Knife") { true }
          FS3Combat.should_receive(:inflict_damage).with(@char, "M", "Knife - Arm", true, true) {}
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
        
        describe :update_ammo do
          before do
            @combatant.stub(:save) {} 
          end
          
          it "should not do anything if the weapon doesn't use ammo" do
            @combatant.ammo = nil
            @combatant.update_ammo(1)
            @combatant.ammo.should be_nil
          end
          
          it "should adjust ammo by the number of bullets" do
            @combatant.ammo = 15
            @combatant.update_ammo(3)
            @combatant.ammo.should eq 12
          end
        end
        
        describe :attack_target do    
          before do
            @target = double
            @target.stub(:name) { "Target" }
            @combatant.stub(:weapon) { "Knife" }
            @target.stub(:stance) { "Normal" }
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
              @target.stub(:determine_hitloc) { "Head" }
              @combatant.stub(:weapon) { "Knife" }
              FS3Combat.stub(:weapon_is_stun?).with("Knife") { false }
              @target.stub(:do_damage)
              @target.stub(:determine_damage) { "M" }
            end
        
            describe "single fire" do
              before do 
                @target.stub(:roll_defense) { 2 }              
              end
          
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
                @target.should_receive(:determine_damage).with("Head", "Knife") { "M" }
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
                @target.stub(:roll_defense) { 2 }
                @target.should_receive(:do_damage).with("M", "Knife", "Body")
                @combatant.attack_target(@target, "Right Leg")
              end
            end
          end
        end
      end
    end
  end