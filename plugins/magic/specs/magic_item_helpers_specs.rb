module AresMUSH
  module Magic
    describe Magic do

      before do 
        @char = double
        allow(@char).to receive(:magic_item_equipped) {"Item"}
      end

      describe :magic_item_weapon_specials do
        before do
          @combatant = double
          allow(@combatant).to receive(:npc) {false}
          allow(@combatant).to receive(:associated_model) {@char}
          
        end

        subject do 
          Magic.magic_item_weapon_specials(@combatant)
        end

        it "returns nil if combatant is an NPC" do
          allow(@combatant).to receive(:npc) {false}
          expect(subject).to eq [nil]
        end

        it "returns nil if no item is equipped" do
          allow(@char).to receive(:magic_item_equipped) {"None"}
          expect(subject).to eq nil
        end

        it "returns the defined specials on the item" do
          allow(@char).to receive(:magic_item_equipped) {"Item"}
          allow(Global).to receive(:read_config).with("magic-items", "Item", "weapon_specials") {"Fire"}
          expect(subject).to eq ["Fire"]       
        end

        it "returns an empty array if no specials are defined on the item" do
          allow(@char).to receive(:magic_item_equipped) {"Item"}
          allow(Global).to receive(:read_config).with("magic-items", "Item", "weapon_specials") {}
          expect(subject).to eq [nil]            
        end
        
      end

      describe :magic_item_armor_specials do
        before do
          @combatant = double
          allow(@combatant).to receive(:npc) {false}
          allow(@combatant).to receive(:associated_model) {@char}          
        end

        subject do 
          Magic.magic_item_armor_specials(@combatant)
        end

        it "returns nil if combatant is an NPC" do
          allow(@combatant).to receive(:npc) {false}
          expect(subject).to eq [nil]
        end

        it "returns nil if no item is equipped" do
          allow(@char).to receive(:magic_item_equipped) {"None"}
          expect(subject).to eq nil
        end

        it "returns the defined specials on the item" do
          allow(@char).to receive(:magic_item_equipped) {"Item"}
          allow(Global).to receive(:read_config).with("magic-items", "Item", "armor_specials") {"Fire"}
          expect(subject).to eq ["Fire"]       
        end

        it "returns an empty array if no specials are defined on the item" do
          allow(@char).to receive(:magic_item_equipped) {"Item"}
          allow(Global).to receive(:read_config).with("magic-items", "Item", "armor_specials") {}
          expect(subject).to eq [nil]            
        end
        
      end



    end
  end
end