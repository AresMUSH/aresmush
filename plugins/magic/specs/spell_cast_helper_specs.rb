module AresMUSH
  module Magic
    describe Magic do
      before do 
        @char = double
        allow(@char).to receive(:name)
        stub_translate_for_testing
      end

      describe :spell_skill do
        before do 
          allow(@char).to receive(:is_npc?) 
          allow(Global).to receive(:read_config).with("spells", "Spell", "school") {"Fire"}
          
        end

        subject do
          Magic.spell_skill(@char, "Spell")
        end

        context "when the caster is an npc" do
          it "returns the spell's school" do 
            allow(@char).to receive(:is_npc?) {true}
            expect(subject[:cast_mod]).to eq 0
            expect(subject[:skill]).to eq "Fire"
          end
        end

        context "when the caster has the spell's school" do
          it "returns the spell's school" do      
            allow(@char).to receive(:group) {"Fire"}
            expect(subject[:cast_mod]).to eq 0
            expect(subject[:skill]).to eq "Fire"
          end
        end

        context "when the caster does not have the spell's school" do

          it "returns the magic skill and a cast mod of skill * 2" do
            allow(@char).to receive(:group) {"Ice"}
            allow(Global).to receive(:read_config).with("magic", "magic_attribute") {"Attribute"}
            allow(FS3Skills).to receive(:ability_rating).with(@char, "Attribute") {2}
            expect(subject[:cast_mod]).to eq 4
            expect(subject[:skill]).to eq "Attribute"
          end
        end
      end

      describe :cast_noncombat_spell do
        before do
          @spell = {:is_shield => false, rounds: 10, heal_points: nil}
          
          @bob = double
          allow(Character).to receive(:named).with("Jane") {@char}
          allow(Character).to receive(:named).with("Bob") {@bob}
          allow(Character).to receive(:named).with("Jill") 
          allow(Global).to receive(:read_config).with("spells", "Spell") {@spell}          
          allow(@char).to receive(:name) {"Jane"}
          allow(@bob).to receive(:name) {"Bob"}
          stub_translate_for_testing
        end

        subject do 
          Magic.cast_noncombat_spell("Jill", [@char, @bob], "Spell")
        end

        context "when the caster is an NPC" do
          it "returns a message" do
            expect(Magic.cast_noncombat_spell("Jane", "npc_target", "Spell")).to eq ["magic.casts_spell"]
          end
        end

        context "when a relevant shield is active" do
          
          context "when the caster is targeting themselves" do
            it "returns a casts spell msg" do
              expect(Magic.cast_noncombat_spell("Jane", [@char], "Spell")).to eq ["magic.casts_spell"]
            end
          end

          context "when they are using a potion" do
            it "returns a used potion message" do
              expect(Magic).to receive(:get_potion_message)
              Magic.cast_noncombat_spell("Jill", [@char], "Spell", mod = nil, result = nil, true)
            end

          end

          context "when the shield fails" do

            before do 
              allow(Magic).to receive(:stopped_by_shield?) {{hit: true, msg: "Shield fails"}}
            end

            it "returns a shield fails message and a spell effects message" do
              expect(subject).to eq ["Shield fails", "magic.casts_spell_on_target"]
            end

           it "applies relevant spell effects" do
              @spell = {"is_shield" => true, "rounds" => 10, "heal_points" => 1}
              allow(Magic).to receive(:cast_shield) {["Cast Shield"]}
              allow(Magic).to receive(:cast_heal) {["Cast Heal"]}
              expect(subject).to eq ["Shield fails", "Cast Shield", "Cast Heal"]
            end
          end

          context "when the shield holds" do
            before do
              allow(Magic).to receive(:stopped_by_shield?) {{hit: false, msg: "Shield holds"}}
            end

            it "returns a shield held message and does not apply spell effects" do
              @spell = {"is_shield" => true, "rounds" => 10, "heal_points" => 1}
              allow(Magic).to receive(:cast_shield) {["Cast Shield"]}
              allow(Magic).to receive(:cast_heal) {["Cast Heal"]}
              expect(Magic.cast_noncombat_spell("Bob", [@char], "Spell")).to eq ["Shield holds"]
            end

          end

        end

        context "when no relevant shield is active" do
          before do
            allow(Magic).to receive(:stopped_by_shield?) {nil}
          end
          it "returns relevant spell messages" do 
            
            @spell = {"is_shield" => true, "rounds" => 10, "heal_points" => 1}
            allow(Magic).to receive(:cast_shield) {["Cast Shield"]}
            allow(Magic).to receive(:cast_heal) {["Cast Heal"]}
            expect(subject).to eq ["Cast Shield", "Cast Heal"]
          end

          context "when the caster is the only target" do
            it "returns casts_spell" do
              expect(Magic.cast_noncombat_spell("Jane", [@char], "Spell")).to eq ["magic.casts_spell"]
            end
          end

          context "when the caster is not the target" do
            it "returns casts_spell_on_target" do
              expect(subject).to eq ["magic.casts_spell_on_target"]
            end
          end

          context "when the caster is one of many targets" do
            it "returns casts_spell_on_target" do
              expect(Magic.cast_noncombat_spell("Jane", [@char, @bob], "Spell")).to eq ["magic.casts_spell_on_target"]
            end            
          end

        end

      end

      describe :cast_shield do
        before do
          @target = double          
          allow(Magic).to receive(:get_associated_model) {@target}
          @shield = double
          allow(@shield).to receive(:strength)
          allow(Magic).to receive(:find_shield_named) {@shield}
          allow(@target).to receive(:name)
          allow(Magic).to receive(:log_magic_msg)
          allow(Global).to receive(:read_config) {"Type"}
          allow(@shield).to receive(:update)
          
        end

        subject do 
          Magic.cast_shield("Jane", @target, "Spell", 20, 3)
        end

        context "when a matching shield already exists" do
          it "updates the shield's strength and rounds" do            
            expect(@shield).to receive(:update).with(strength: 3)
            expect(@shield).to receive(:update).with(rounds: 20)
            subject
          end
        end

        context "when no matching shield exists" do
          it "creates a new shield" do
            allow(Magic).to receive(:find_shield_named) {nil}
            expect(AresMUSH::MagicShields).to receive(:create).with({name: "Spell", strength: 3, rounds: 20, character: @target, npc: @target})
            #Not sure how to make this test true since I re-look up the shield after creation.
            subject
          end
        end

        context "when cast via potion" do
          it "returns use_potion_shield" do
            expect(Magic.cast_shield("Jane", @target, "Spell", 20, 3, true)).to eq ["magic.use_potion_shield"]
          end
        end

        it "returns cast_shield" do
          expect(subject).to eq ["magic.cast_shield"]
        end
      end

      describe :cast_heal do

        before do 
          allow(Magic).to receive(:associated_model) {@char}
          @wound = double          
          stub_translate_for_testing
        end

        subject do
          Magic.cast_heal("Jane", @char, "Spell", 2)
        end

        it "returns cast_heal_no_effect if there is no healable wound" do
          allow(FS3Combat).to receive(:worst_treatable_wound) {nil} 
          expect(subject).to eq ["magic.cast_heal_no_effect"]
        end

        context "when Death is installed and the target is KO'd" do
          it "returns cast_ko_heal" do

          end

          it "applies heal points to the wound" do

          end

          it "does something with Death?" do

          end


        end

        it "returns cast_heal and applies heal points to the wound" do
          allow(FS3Combat).to receive(:worst_treatable_wound) {@wound} 
          expect(FS3Combat).to receive(:heal).with(@wound, 2) 
          expect(subject).to eq ["magic.cast_heal"]
        end

      end

      describe :cast_weapon do
        before do 
          allow(Magic).to receive(:set_magic_weapon)
        end

        subject do
          Magic.cast_weapon(@char, @char, "Spell", "Weapon")          
        end

        before do
          allow(Global).to receive(:read_config).with("spells", "Spell", "armor") {nil}
        end

        it "sets the weapon" do
          expect(Magic).to receive(:set_magic_weapon).with(@char, @char, "Weapon")
          subject        
        end

        it "returns an empty array if the spell also sets armor" do 
          allow(Global).to receive(:read_config).with("spells", "Spell", "armor") {"Armor"}
          expect(subject).to eq []
        end

        it "returns casts_spell" do
          expect(subject).to eq ["magic.casts_spell"]
        end
      end

      describe :cast_weapon_specials do
        before do
          @spell = {"attack_mod" => nil, "defense_mod" => nil, "lethal_mod" => nil, "spell_mod" => nil, "rounds" => 10, "heal_points" => nil}
          allow(Global).to receive(:read_config).with("spells", "Spell") {@spell}
          @target = double
          allow(@target).to receive(:name) {"Bob"}
          allow(@target).to receive(:weapon) {"Knife"}
          allow(@target).to receive(:associated_model)
          allow(Magic).to receive(:set_magic_weapon)
          allow(Magic).to receive(:magic_weapon_specials) {[]}
          allow(FS3Combat).to receive(:worst_treatable_wound) {nil}
        end

        subject do 
          Magic.cast_weapon_specials(@char, @target, "Spell", "Specials")
        end

        context "when there are specials from items and previous spells" do
          it "sets the weapon with specials" do
            allow(Magic).to receive(:magic_weapon_specials) {["Fire", "Ice"]}
            expect(Magic).to receive(:set_magic_weapon).with(nil, @target, "Knife", ["Specials", "Fire", "Ice"])
            subject
          end
        end


        it "sets the weapon with specials" do
          expect(Magic).to receive(:set_magic_weapon).with(nil, @target, "Knife", ["Specials"])
            subject
        end

        context "when the spell also heals and there's a wound to heal" do
          it "returns an empty array" do
            @wound = double
            allow(FS3Combat).to receive(:worst_treatable_wound) {double}
            @spell = {"attack_mod" => nil, "defense_mod" => nil, "lethal_mod" => nil, "spell_mod" => nil, "rounds" => 10, "heal_points" => 2}
            expect(subject).to eq []
          end
        end

        context "when the spell also sets a mod" do
          it "returns an empty array" do
            @spell = {"attack_mod" => 1, "defense_mod" => nil, "lethal_mod" => nil, "spell_mod" => nil, "rounds" => 10, "heal_points" => nil}
            expect(subject).to eq []
          end
        end

        context "when the spell is cast on oneself" do
          it "returns casts_spell" do
            allow(@char).to receive(:associated_model)
            allow(@char).to receive(:weapon) {"Knife"}
            expect(Magic.cast_weapon_specials(@char, @char, "Spell", "Specials")).to eq ["magic.casts_spell"]
          end
        end

        context "when the spell is cast on a different target" do
          it "returns casts_spell_on_target" do
            expect(subject).to eq ["magic.casts_spell_on_target"]
          end
        end

      end

      describe :cast_armor do
        before do 
          allow(FS3Combat).to receive(:set_armor)
        end

        subject do
          Magic.cast_armor(@char, @char, "Spell", "Armor")          
        end

        it "sets the armor" do
          expect(FS3Combat).to receive(:set_armor).with(@char, @char, "Armor")
          subject        
        end
        context "when the caster is the target " do
          it "returns casts_spell" do
            expect(subject).to eq ["magic.casts_spell"]
          end
        end

        context "when the caster is not the target" do
          it "returns casts_spell_on_target" do
            @target = double
            allow(@target).to receive(:name)
            expect(Magic.cast_armor(@char, @target, "Spell", "Armor")).to eq ["magic.casts_spell_on_target"]
          end
        end
        
      end


      describe :cast_armor_specials do
        
      end

      describe :cast_auto_revive do
        before do
          allow(@char).to receive(:update)
          allow(FS3Combat).to receive(:emit_to_combatant)
        end

        subject do 
          Magic.cast_revive(@char, @char, "Spell")
        end

        it "unkos the target" do
          expect(@char).to receive(:update).with(is_ko: false)
          subject
        end

        it "tells the target they've been revived" do
          expect(FS3Combat).to receive(:emit_to_combatant)
          # .with(@char, "magic.been_revived")
          subject
        end

        it "returns cast_revive" do
          expect(subject).to eq ["magic.cast_revive"]
        end
      end

      describe :cast_resurrection do
        before do
          allow(FS3Combat).to receive(:emit_to_combatant)
        end

        subject do
          Magic.cast_resurrection(@char, @char, "Spell")
        end

        it "raises the character from the dead" do
          #Write this once Death is re-integrated
        end

        it "emits been_resed to the target" do
          expect(FS3Combat).to receive(:emit_to_combatant).with(@char, "magic.been_resed")
          subject
        end

        it "returns cast_res" do
          expect(subject).to eq ["magic.cast_res"]
        end

      end

      describe :cast_inflict_damage do 
        before do
          @target = double
          allow(@target).to receive(:associated_model)
          allow(FS3Combat).to receive(:inflict_damage)
          allow(@target).to receive(:update)
          allow(@target).to receive(:name)
          allow(@target).to receive(:damaged_by) {["Other"]}
          allow(@char).to receive(:name) {"Caster"}

        end

        subject do 
          Magic.cast_inflict_damage(@char, @target, "Spell", "FLESH", "Spell inflicted damage")
        end

        it "sets the target to freshly damaged" do
          expect(@target).to receive(:update).with(freshly_damaged: true)
          subject
        end

        it "adds the caster to the damaged_by list" do
          expect(@target).to receive(:update).with(damaged_by: ["Other", "Caster"])
          subject
        end

        it "returns cast_damage" do
          expect(subject).to eq ["magic.cast_damage"]
        end
      

      end

      describe :cast_mod do

        before do
          allow(Magic).to receive(:stopped_by_shield) {nil}

        end

        subject do
          Magic.cast_mod(@char, @target, "Spell", "Damage", 10, 10)
        end

      end

      describe :update_spell_mods do
        
      end

      describe :cast_stance do
        #Nixing this, it sucks
      end

      describe :cast_combat_roll do

      end

      describe :cast_stun do

      end

      describe :cast_explosion do
        #Do I need this?
      end

      describe :cast_suppress do

      end
       
      describe :cast_attack_target do 

      end
    
    end
  end
end