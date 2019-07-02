module AresMUSH
  module FS3Combat
    describe FS3Combat do
      include GlobalTestHelper

      describe :npc do
        before do
          @npc = Npc.new(level: "Goon")
          allow(FS3Combat).to receive(:npc_type).with("Goon") { { "Default" => 3, "Piloting" => 2, "Reflexes" => 4 } }
        end
        
        it "should return default for an unlinsted action skill" do
          allow(FS3Skills).to receive(:get_ability_type).with("Firearms") { :action }
          rating = @npc.ability_rating("Firearms")
          expect(rating).to eq 3
        end

        it "should return default/2 for an unlinsted attribute" do
          allow(FS3Skills).to receive(:get_ability_type).with("Brawn") { :attribute }
          rating = @npc.ability_rating("Brawn")
          expect(rating).to eq 1
        end

        it "should return specific skill if found" do
          allow(FS3Skills).to receive(:get_ability_type).with("Piloting") { :action }
          rating = @npc.ability_rating("Piloting")
          expect(rating).to eq 2
        end
        
        it "should return specific skill if found" do
          allow(FS3Skills).to receive(:get_ability_type).with("Reflexes") { :attribute }
          rating = @npc.ability_rating("Reflexes")
          expect(rating).to eq 4
        end
        
      end
    end
  end
end
