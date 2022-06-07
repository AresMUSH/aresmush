module AresMUSH
  module Magic
    describe Magic do

      before do
      
        @spell1 = double
        allow(@spell1).to receive(:name) { "Spell1" }
        allow(@spell1).to receive(:learning_complete) { true }
        allow(@spell1).to receive(:level) { 1 }
        allow(@spell1).to receive(:school) { "Fire" }

        @spell2 = double
        allow(@spell2).to receive(:name) { "Spell2" }
        allow(@spell2).to receive(:learning_complete) { false }
        allow(@spell2).to receive(:level) { 2 }  
        allow(@spell2).to receive(:school) { "Fire" }  

        @spell3 = double
        allow(@spell3).to receive(:name) { "Spell3" }
        allow(@spell3).to receive(:learning_complete) { true }
        allow(@spell3).to receive(:level) { 3 }    
        allow(@spell3).to receive(:school) { "Fire" }

        @spellalso3 = double
        allow(@spellalso3).to receive(:name) { "SpellAlso3" }
        allow(@spellalso3).to receive(:learning_complete) { true }
        allow(@spellalso3).to receive(:level) { 3 }    
        allow(@spellalso3).to receive(:school) { "Fire" }
        
        @char = double
        allow(@char).to receive(:spells_learned) {[@spell1, @spell2, @spell3, @spellalso3] }

        @combatant = double
        allow(@combatant).to receive(:class) { Combatant }
        allow(@combatant).to receive(:is_npc?) { false }
        allow(@combatant).to receive(:associated_model) { @char }

        allow(Magic).to receive(:item_spells).with(@char) { ["Item"] }
        allow(Magic).to receive(:find_spell_school) { "Fire" }
      end

      describe :knows_spell? do
        it "should let NPCs know all spells" do
          @npc = double
          allow(@npc).to receive(:is_npc?) { true }
          allow(@npc).to receive(:class) { Combatant }
          expect(Magic.knows_spell?(@npc, "Spell")).to eq true
        end

        it "should let characters cast spells from magic items in combat" do
          expect(Magic.knows_spell?(@combatant, "Item")).to eq true
        end

        it "should let characters cast spells from magic items out of combat" do
          expect(Magic.knows_spell?(@char, "Item")).to eq true
        end

        it "should let characters cast spells they have fully learned out of combat" do
          expect(Magic.knows_spell?(@char, "Spell1")).to eq true
        end

        it "should not let characters cast spells they have not fully learned out of combat" do
          expect(Magic.knows_spell?(@char, "Spell2")).to eq false
        end

        it "should let characters cast spells they have fully learned in combat" do
          expect(Magic.knows_spell?(@combatant, "Spell1")).to eq true
        end

        it "should not let characters cast spells they have not fully learned in combat" do
          expect(Magic.knows_spell?(@combatant, "Spell2")).to eq false
        end

      end

      describe :knows_potion? do

        it "should return true if a character has fully learned the potion spell" do
          allow(@spell1).to receive(:name) { "Potion_Spell" }
          allow(Global).to receive(:read_config).with("magic", "potion_spell") { "Potion_Spell"}
          expect(Magic.knows_potion?(@char)).to eq true
        end

        it "should return true if a character has the potion spell on a magic item" do
          allow(Magic).to receive(:item_spells).with(@char) { "Potion_Spell" }
          allow(Global).to receive(:read_config).with("magic", "potion_spell") { "Potion_Spell"}
          expect(Magic.knows_potion?(@char)).to eq true
        end

        it "should return false if a character has not fully learned the potion spell" do
          allow(@spell2).to receive(:name) { "Potion_Spell" }
          allow(Global).to receive(:read_config).with("magic", "potion_spell") { "Potion_Spell"}
          expect(Magic.knows_potion?(@char)).to eq true
        end

      end

      describe :previous_level_spell? do 

        it "should return true if the spell is level 1" do
          allow(Magic).to receive(:find_spell_level) { 1 }
          expect(Magic.previous_level_spell?(@char, "Spell1")).to eq true
        end

        it "should return true if a character has fully learned a spell of the previous level in the same school" do
          allow(Magic).to receive(:find_spell_level) { 2 }
          expect(Magic.previous_level_spell?(@char, "Spell2")).to eq true
        end

        it "should return false if a character has only started learning a spell of the previous level in the same school" do
          allow(Magic).to receive(:find_spell_level) { 3 }
          expect(Magic.previous_level_spell?(@char, "Spell3")).to eq false
        end

        it "should return false if a character has fully learned a spell of the previous level in a different school" do
          allow(@spell1).to receive(:school) { "NotFire" }
          allow(Magic).to receive(:find_spell_level) { 2 }
          expect(Magic.previous_level_spell?(@char, "Spell2")).to eq false
        end

      end

      describe :equal_level_spell? do 

        it "should return true if a character has fully learned a spell of the same level in the same school" do
          allow(Magic).to receive(:find_spell_level) { 3 }          
          expect(Magic.equal_level_spell?(@char, "Spell3")).to eq true
        end

        it "should return false if a character has only started learning a spell of the same level in the same school" do
          allow(Magic).to receive(:find_spell_level) { 2 }
          expect(Magic.equal_level_spell?(@char, "Spell3")).to eq false
        end

        it "should return false if a character has fully learned a spell of the same level in a different school" do
          allow(@spell1).to receive(:school) { "NotFire" }
          allow(Magic).to receive(:find_spell_level) { 1 }
          expect(Magic.equal_level_spell?(@char, "Spell2")).to eq false
        end

      end      

      describe :can_discard? do
        context "when a character does not have another spell at the same level in the same school" do
          subject do
            Magic.can_discard?(@char, @spell3)
          end

          before do
            allow(@spellalso3).to receive(:level) { 4 }
            allow(@char).to receive(:spells_learned) {[@spell1, @spell2, @spell3, @spellalso3] }
          end

          context "and the spell is level 1" do
            it "allows a character to discard a spell" do
              allow(@spell3).to receive(:level) { 1 }
              expect(Magic.can_discard?(@char, @spell3)).to eq true
            end
          end

          context "and they have a higher level spell in the same school" do  
            it "does not let a character discard a spell" do
              
              expect(Magic.can_discard?(@char, @spell3)).to eq false
            end
          end

          context "and they are currently learning a higher level spell in the same school" do
            
            before do
              allow(@spellalso3).to receive(:learning_complete) { false }
              
            end

            it "does not let a character discard a spell" do
              expect(Magic.can_discard?(@char, @spell3)).to eq false
            end

          end

          context "and they do not have and are not learning a higher level spell in the same school" do

            before do
              allow(@spellalso3).to receive(:level) { 3 }
            end
            
            it "allows a character to discard a spell" do              
              expect(subject).to eq true
            end
          end

        end

        context "when a character has another spell at the same level in the same school" do

          subject do
            Magic.can_discard?(@char, @spell3)
          end
        
          context "and they have a higher level spell in the same school" do
            it "allows a character to discard a spell" do
              allow(@spell2).to receive(:level) { 4 }
              expect(subject).to eq true
            end
          end

          context "and they are currently learning a higher level spell in the same school" do
            it "allows a character to discard a spell" do
              allow(@spell2).to receive(:level) { 4 }
              expect(subject).to eq true
            end            
          end

        end

      end



          
    end
  end
end 