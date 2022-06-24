module AresMUSH
  module Magic
    describe Magic do
      before do 
        @char = double

      end

      describe :spell_skill do
        before do 
          allow(@char).to receive(:npc) 
          allow(Global).to receive(:read_config).with("spells", "Spell", "school") {"Fire"}
          
        end

        subject do
          Magic.spell_skill(@char, "Spell")
        end

        context "when the caster is an npc" do
          it "returns the spell's school" do 
            allow(@char).to receive(:npc) {true}
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

      describe :spell_level_mod do

      end

      describe :cast_noncombat_spell do

      end

      describe :cast_shield do

      end

      describe :cast_heal do

      end

      describe :cast_weapon do

      end

      describe :cast_weapon_specials do

      end

      describe :cast_armor do

      end

      describe :cast_armor_specials do

      end

      describe :cast_auto_revive do

      end

      describe :cast_resurrection do

      end

      describe :cast_inflict_damage do 

      end

      describe :cast_mod do

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