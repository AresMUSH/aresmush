module AresMUSH
  module Magic
    describe Magic do

      describe :knows_spell? do
        it "should let NPCs know all spells" do
          @npc = double
          allow(@npc).to receive(:is_npc?) { true }
          allow(@npc).to receive(:class) { Combatant }
          expect(Magic.knows_spell?(@npc, "Spell")).to eq true
        end

        it "should let characters cast spells from magic items inside of combat" do
          @combatant = double
          @char = double
          allow(@combatant).to receive(:class) { Combatant }
          allow(@combatant).to receive(:is_npc?) { false }
          allow(@combatant).to receive(:associated_model) { @char }
          @spell1 = double
          @spell2 = double
          allow(@spell1).to receive(:name) { "Spell1" }
          allow(@spell2).to receive(:name) { "Spell2" }
          allow(@spell1).to receive(:learning_completee) { true }
          allow(@spell2).to receive(:learning_completee) { false }
          allow(@char).to receive(:spells_learned) {[@spell1, @spell2] }
          allow(Magic).to receive(:item_spells).with(@char) { "Spell3" }
          expect(Magic.knows_spell?(@char, "Spell3")).to eq true
        end

        it "should let characters cast spells from magic items outside of combat" do
          @char = double
          @spell1 = double
          @spell2 = double
          allow(@spell1).to receive(:name) { "Spell1" }
          allow(@spell2).to receive(:name) { "Spell2" }
          allow(@spell1).to receive(:learning_completee) { true }
          allow(@spell2).to receive(:learning_completee) { false }
          allow(@char).to receive(:spells_learned) {[@spell1, @spell2] }
          allow(Magic).to receive(:item_spells).with(@char) { "Spell3" }
          expect(Magic.knows_spell?(@char, "Spell3")).to eq true
        end

      end

      # describe :knows_potion? do
      #   it "should return true if a character can make potions" do
      #     @char = double
      #     spell = double
      #     allow(spell).to receive(:name) { "Potion_Spell" }
      #     @spells_learned = double
      #     allow(@spells_learned).to receive(:spell) 
      #     allow(@char).to receive(:spells_learned) { @spells_learned }
      #     # @char.stub(:spells_learned) {nil}
      #     # list = ["Potion_Spell"]
      #     allow(Global).to receive(:read_config).with("magic", "potion_spell") { "Potion_Spell"}
      #     expect(Magic.knows_potion?(@char)).to eq true
      #   end
      # end


          
    end
  end
end 